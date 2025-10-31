defmodule DAU.Slack do
  @moduledoc """
  Module for handling Slack-related operations including message processing,
  channel management, and event handling.

  - The payload processing will start from the process_message() function (called from the slack_controller).
  - This function would first validate the received event againts the DAU.Slack.SlackEvent schema.
  - After receiving a valid %SlackEvent{} struct, the get_event_type() function analyses the type of event: new, edit, delete, broadcasted, repeated (in case Slack sends
  the same payload again). The broadcasted here refers to the event when a thread message is "also send to channel".
  - After receiveing the event's type, a relevant function is further called to handle the event.

  """

  import Ecto.Query
  alias DAU.Repo
  alias DAU.Slack.Channel
  alias DAU.Slack.Message
  alias DAU.Slack.Event
  alias DAU.Slack.SlackEvent
  require Logger

  def create_slack_event_from_event_id(event_id) do
    %Event{} |> Event.changeset(%{event_id: event_id}) |> Repo.insert()
  end

  def get_event_from_event_id(event_id) do
    Repo.get_by(Event, event_id: event_id)
  end

  def get_slack_channel_from_channel_id(channel_id) do
    Repo.get_by(Channel, channel_id: channel_id)
  end

  def create_slack_channel(attrs) do
    %Channel{} |> Channel.changeset(attrs) |> Repo.insert()
  end

  def create_slack_message(attrs) do
    %Message{} |> Message.changeset(attrs) |> Repo.insert()
  end

  def get_unique_slack_message(ts, channel_id, team_id) do
    Repo.get_by(Message, ts: ts, channel_id: channel_id, team: team_id)
  end

  def get_all_channels() do
    Repo.all(Channel)
  end

  def get_all_channel_messages(channel_id) do
    Message
    |> where([m], m.channel_id == ^channel_id)
    |> preload([
      :parent,
      thread_messages: ^from(t in Message, order_by: [asc: t.ts_utc, asc: t.id])
    ])
    |> order_by([m], asc: m.ts_utc, asc: m.id)
    |> Repo.all()
  end

  def validate_slack_event(event) when is_map(event) do
    event_message =
      if not is_nil(get_in(event, ["message"])) do
        %{
          message_ts: get_in(event, ["message", "ts"]),
          message_text: get_in(event, ["message", "text"]),
          message_subtype: get_in(event, ["message", "subtype"]),
          message_edited: get_in(event, ["message", "edited"]),
          message_thread_ts: get_in(event, ["message", "thread_ts"])
        }
      else
        nil
      end

    ts = get_in(event, ["ts"])

    ts_utc =
      case parse_unix_string_to_utc_datetime(ts) do
        {:ok, dt} ->
          dt

        {:error, reason} ->
          Logger.warning("Failed to parse timestamp #{ts}: #{inspect(reason)}")
          nil
      end

    mapped_attrs = %{
      event_type: get_in(event, ["type"]),
      event_subtype: get_in(event, ["subtype"]),
      event_deleted_ts: get_in(event, ["deleted_ts"]),
      previous_message: get_in(event, ["previous_message"]),
      channel: get_in(event, ["channel"]),
      ts: ts,
      ts_utc: ts_utc,
      user: get_in(event, ["user"]),
      text: get_in(event, ["text"]),
      thread_ts: get_in(event, ["thread_ts"]),
      event_message: event_message
    }

    case SlackEvent.new(mapped_attrs) do
      {:ok, slack_event} ->
        {:ok, slack_event}

      {:error, changeset} ->
        {:error,
         "Failed to create Slack Event from Payload event. Error in Changeset: #{inspect(changeset)}"}

      _ ->
        {:error, "Failed to create Slack Event from Payload event."}
    end
  end

  def validate_slack_event(_attrs) do
    {:error, "Passed event is not a map."}
  end

  @doc """
  Converts Unix epoch time string into a UTC timestamp.
  Example:
  iex(6)> TestModule.parse_epoch_string_to_utc_datetime("1757316344.296449")
          {:ok, ~U[2025-09-08 07:25:44.296449Z]}

  """
  def parse_unix_string_to_utc_datetime(epoch_str) when is_binary(epoch_str) do
    epoch_str = String.trim(epoch_str)

    {secs_str, frac_str} =
      case String.split(epoch_str, ".", parts: 2) do
        # no fraction provided
        [s] -> {s, ""}
        [s, f] -> {s, f}
      end

    with {secs, ""} <- Integer.parse(secs_str),
         frac6 = frac_str |> String.pad_trailing(6, "0") |> String.slice(0, 6),
         {micros_frac, ""} <- Integer.parse(frac6),
         micros = secs * 1_000_000 + micros_frac,
         {:ok, dt} <- DateTime.from_unix(micros, :microsecond) do
      {:ok, dt}
    else
      :error -> {:error, :invalid_number}
      {:error, _} -> {:error, :invalid_unix_time}
      _ -> {:error, :invalid_format}
    end
  end

  @doc """
  Processes a Slack message event based on its type (delete, edit, or new).

  Returns `{:ok, result}` on success or `{:error, reason}` on failure.
  """
  @spec process_message(map(), String.t(), String.t(), map()) :: {:ok, any()} | {:error, atom()}
  def process_message(event, event_id, team_id, payload) do
    with {:ok, _created_event} <- create_slack_event_from_event_id(event_id),
         {:ok, slack_event} <- validate_slack_event(event) do
      case get_event_type(slack_event, event, team_id) do
        {:ok, :delete} ->
          process_message_delete(slack_event, team_id, payload)

        {:ok, :message_broadcast} ->
          process_message_broadcast(slack_event, team_id, payload)

        {:ok, :edit} ->
          process_message_edit(slack_event, event, team_id, payload)

        {:ok, :duplicate} ->
          {:ok, :duplicate_message}

        {:ok, :ignore} ->
          {:ok, :ignore}

        {:ok, :new} ->
          process_new_slack_message(slack_event, event, team_id, payload)

        _ ->
          Logger.warning("Unknown event type for message: #{inspect(event)}")
          {:error, :unknown_event_type}
      end
    else
      {:error, error} ->
        Logger.error("Failed to create slack event: #{inspect(error)}")
        {:error, :error_creating_event}
    end
  end

  defp ignore_preview?(raw_event) do
    event_message_attachments = get_in(raw_event, ["message", "attachments"])
    event_prev_message_attachments = get_in(raw_event, ["previous_message", "attachments"])
    edited = get_in(raw_event, ["message", "edited"])

    case edited do
      nil ->
        if is_nil(event_prev_message_attachments) and not is_nil(event_message_attachments) do
          true
        else
          false
        end

      _edited ->
        false
    end
  end

  @doc """
  Get the event payload type.

  Specifically regarding Edit payloads:

  When a message has a preview, after receiving the new message payload, another payload gets sent with the preview attachment.
  This payload is treated as an edit payload. It doesn't change the contents BUT it marks the is_edited property to true.
  The private function (ignore_preview?) would compare the previous message and current message (both are present in the payload), if current message has an
  attachment and the previous one didn't, then ignore. It also checks for the "edit" keyowrd in event.message, if present, process it regardless anything.
  Some unique scenarios:
  - User sends message with some text and 2 images, then deleted one image: In the payload we won't see edited key, but the payload is still for edit. Therefore,
  cannot use strict check for the "edited" keyword.
  - User sends a link (generates a preview). Then later, in the edit adds one more link (with a new preview), After editing, it sends 2 payloads, but both of them has
  "edited" keyword in the event.message. But we can just process it, as is_edited is already set to true before, so this won't change anything now.
  """
  def get_event_type(%SlackEvent{} = event, raw_event, team_id) do
    event_subtype = event.event_subtype
    event_deleted_ts = event.event_deleted_ts
    previous_message = event.event_message || nil
    message_subtype = get_in(event, [Access.key(:event_message), Access.key(:message_subtype)])
    message_edited = get_in(event, [Access.key(:event_message), Access.key(:message_edited)])

    cond do
      event_subtype == "message_deleted" or message_subtype == "tombstone" or
          !is_nil(event_deleted_ts) ->
        {:ok, :delete}

      message_subtype == "thread_broadcast" ->
        {:ok, :message_broadcast}

      (!is_nil(message_edited) or !is_nil(previous_message)) and not ignore_preview?(raw_event) ->
        {:ok, :edit}

      ignore_preview?(raw_event) ->
        {:ok, :ignore}

      check_repeated_payload?(event, team_id) ->
        {:ok, :duplicate}

      true ->
        {:ok, :new}
    end
  end

  def get_and_update_channel_details(channel_id, %Channel{} = channel) do
    slack_auth_token = System.get_env("SLACK_AUTH_TOKEN")

    headers = [
      {"Authorization", "Bearer #{slack_auth_token}"},
      {"Content-Type", "application/x-www-form-urlencoded"}
    ]

    case HTTPoison.get("https://slack.com/api/conversations.info?channel=#{channel_id}", headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded_body} = Jason.decode(body)
        channel_res = get_in(decoded_body, ["channel"])

        if !is_nil(channel_res) and is_map(channel_res) do
          channel
          |> Channel.changeset(%{channel_name: get_in(channel_res, ["name"])})
          |> Repo.update()
        end

      _ ->
        Logger.error("Error while updating the channel name: Channel_id: #{inspect(channel_id)}")
    end
  end

  def check_repeated_payload?(%SlackEvent{} = event, team_id) do
    message = event.event_message
    # IO.inspect(message, label: "EVENT MESSAGE IS: ")
    channel_id = event.channel

    channel =
      case get_slack_channel_from_channel_id(channel_id) do
        nil ->
          nil

        channel ->
          channel
      end

    ts =
      if is_nil(message) do
        event.ts
      else
        message.message_ts
      end

    existing_message =
      if is_nil(channel) do
        nil
      else
        get_unique_slack_message(ts, channel.id, team_id)
      end

    if is_nil(existing_message) do
      false
    else
      true
    end
  end

  @doc """
  Processes a message deletion event from Slack.

  Marks the message as deleted in the database if it exists and isn't already marked as deleted.
  Returns `{:ok, :message_deletion_processed}` on success or `{:error, reason}` on failure.
  """
  @spec process_message_delete(%SlackEvent{}, String.t(), map()) ::
          {:ok, atom()} | {:error, atom()}
  def process_message_delete(%SlackEvent{} = event, team_id, _payload) do
    with event_channel_id when not is_nil(event_channel_id) <- event.channel,
         channel when not is_nil(channel) <- get_slack_channel_from_channel_id(event_channel_id),
         ts when not is_nil(ts) <-
           get_in(event, [Access.key(:event_message), Access.key(:message_ts)]) ||
             get_in(event, [Access.key(:event_deleted_ts)]) ||
             event.ts,
         existing_message when not is_nil(existing_message) <-
           get_unique_slack_message(ts, channel.id, team_id) do
      Logger.debug(
        "Processing message deletion for message: #{ts} in channel: #{event_channel_id}"
      )

      if existing_message.is_deleted != true do
        case existing_message
             |> Message.changeset(%{is_deleted: true})
             |> Repo.update() do
          {:ok, _} ->
            :ok

          error ->
            Logger.error("Failed to mark message as deleted: #{inspect(error)}")
            {:error, :failed_to_update_message}
        end
      else
        :already_deleted
      end

      {:ok, :message_deletion_processed}
    else
      nil ->
        Logger.warning("Message to delete not found: #{inspect(event)}")
        {:error, :message_to_delete_not_found}

      error ->
        Logger.error("Error processing message deletion: #{inspect(error)}")
        {:error, :invalid_delete_request}
    end
  end

  @doc """
  Processes an broadcast event for an existing Slack thread message.
  """
  @spec process_message_broadcast(%SlackEvent{}, String.t(), map()) ::
          {:ok, atom()} | {:error, atom()}
  def process_message_broadcast(
        %SlackEvent{event_message: message} = event,
        team_id,
        _payload
      ) do
    with ts <- Map.get(message || %{}, :message_ts, event.ts),
         event_channel_id when not is_nil(event_channel_id) <- event.channel,
         channel when not is_nil(channel) <- get_slack_channel_from_channel_id(event_channel_id),
         existing_message when not is_nil(existing_message) <-
           get_unique_slack_message(ts, channel.id, team_id) do
      case existing_message do
        nil ->
          {:error, :message_to_broadcast_not_found}

        existing_message ->
          updated_attrs = %{
            is_broadcasted: true
          }

          existing_message
          |> Message.changeset(updated_attrs)
          |> Repo.update()

          {:ok, :message_broadcast_processed}
      end
    end
  end

  @doc """
  Processes an edit event for an existing Slack message.

  Updates the message text, URLs, and files if they've changed.
  Returns `{:ok, :message_edit_processed}` on success or `{:error, reason}` on failure.
  """
  @spec process_message_edit(%SlackEvent{}, map(), String.t(), map()) ::
          {:ok, atom()} | {:error, atom()}
  def process_message_edit(
        %SlackEvent{event_message: message} = event,
        raw_event,
        team_id,
        _payload
      ) do
    IO.puts("INSIDE MESSAGE EDIT EVENT HANDLER!")

    with ts <- Map.get(message || %{}, :message_ts, event.ts),
         event_channel_id when not is_nil(event_channel_id) <- event.channel,
         channel when not is_nil(channel) <- get_slack_channel_from_channel_id(event_channel_id),
         existing_message when not is_nil(existing_message) <-
           get_unique_slack_message(ts, channel.id, team_id) do
      text = message.message_text
      urls = get_message_urls(raw_event)
      files = get_message_files(raw_event)

      case existing_message do
        nil ->
          {:error, :message_to_edit_not_found}

        existing_message ->
          updated_attrs = %{
            text: text,
            urls: urls,
            is_edited: true
          }

          existing_files = Map.get(existing_message, :files, [])

          # Only add files to the attrs if it's not nil
          updated_attrs =
            if is_nil(files) do
              if is_nil(existing_files) or existing_files == [] do
                updated_attrs
              else
                Map.put(updated_attrs, :files, [])
              end
            else
              Map.put(updated_attrs, :files, files)
            end

          existing_message
          |> Message.changeset(updated_attrs)
          |> Repo.update()

          {:ok, :message_edit_processed}
      end
    end
  end

  def process_message_edit(_event, _team_id, _payload) do
    Logger.warning("Message not found in event while editing")
    {:error, :message_not_found_in_event_while_editing}
  end

  def process_new_slack_message(%SlackEvent{} = event, raw_event, team_id, _payload) do
    with %{channel: channel_id, ts: ts, ts_utc: ts_utc, user: user, text: text} = _event <- event,
         {:ok, channel} <- get_or_create_channel(channel_id) do
      Logger.debug("Processing new message from user #{user} in channel #{channel_id}")

      message_attrs = %{
        ts: ts,
        ts_utc: ts_utc,
        team: team_id,
        user: user,
        text: text,
        urls: get_message_urls(raw_event),
        channel_id: channel.id,
        parent_id: get_parent_id(event, ts, team_id, channel.id),
        files: get_message_files(raw_event)
      }

      message_attrs =
        if is_nil(message_attrs.files), do: Map.delete(message_attrs, :files), else: message_attrs

      case create_slack_message(message_attrs) do
        {:ok, _message} ->
          {:ok, :new_message_created}

        {:error, changeset} ->
          Logger.error("Failed to create message: #{inspect(changeset.errors)}")
          {:error, :failed_to_create_message}
      end
    else
      {:error, reason} ->
        Logger.error("Invalid message event: #{inspect(reason)}")
        {:error, reason}

      error ->
        Logger.error("Unexpected error processing new message: #{inspect(error)}")
        {:error, :unexpected_error}
    end
  end

  defp get_or_create_channel(channel_id) do
    case get_slack_channel_from_channel_id(channel_id) do
      nil ->
        case create_slack_channel(%{channel_id: channel_id}) do
          {:ok, channel} ->
            # Update channel details asynchronously

            if Application.get_env(:dau, :slack_process_async, true) do
              Task.start(fn ->
                Logger.debug("Updating details for new channel: #{channel_id}")
                get_and_update_channel_details(channel_id, channel)
              end)
            end

            {:ok, channel}

          error ->
            Logger.error("Failed to create channel: #{inspect(error)}")
            {:error, :failed_to_create_channel}
        end

      channel ->
        {:ok, channel}
    end
  end

  @doc """
  Extracts URLs from the event. If there are no URLs, returns nil.

  {{ ... }}
  "event" => %{
    "blocks" => [
      %{
        "block_id" => "SP76j",
        "elements" => [
          %{
            "elements" => [
              %{"text" => "Url with normal text: ", "type" => "text"},
              %{"type" => "link", "url" => "https://github.com"},
              %{"text" => " with text after url", "type" => "text"}
            ],
            "type" => "rich_text_section"
          }
        ],
        "type" => "rich_text"
      }
    ],
    ...
  }
  """
  def get_message_urls(event) do
    (get_in(event, ["blocks"]) || get_in(event, ["message", "blocks"]))
    |> List.wrap()
    |> Enum.flat_map(fn
      %{"elements" => elements} -> extract_urls_from_elements(elements)
      _ -> []
    end)
    |> case do
      [] -> nil
      urls -> urls
    end
  end

  defp extract_urls_from_elements(elements) when is_list(elements) do
    Enum.flat_map(elements, fn
      %{"elements" => inner_elements} -> extract_urls_from_elements(inner_elements)
      %{"type" => "link", "url" => url} -> [url]
      _ -> []
    end)
  end

  @doc false
  @spec extract_urls_from_elements(any()) :: list()
  defp extract_urls_from_elements(_), do: []

  @doc """
  Extracts file information from a Slack event.

  Returns a list of file attributes or `nil` if no valid files are found.
  Filters out tombstoned files.
  """
  @spec get_message_files(map()) :: list(map()) | nil
  def get_message_files(event) do
    with files when not is_nil(files) <-
           get_in(event, ["files"]) || get_in(event, ["message", "files"]),
         filtered_files <- Enum.reject(files, &(get_in(&1, ["mode"]) == "tombstone")),
         true <- length(filtered_files) > 0 do
      Enum.map(filtered_files, &extract_file_attributes/1)
    else
      _ ->
        nil
    end
  end

  @doc false
  @spec extract_file_attributes(map()) :: map()
  defp extract_file_attributes(file) do
    %{
      file_id: get_in(file, ["id"]),
      title: get_in(file, ["title"]),
      mimetype: get_in(file, ["mimetype"]),
      filetype: get_in(file, ["filetype"]),
      url_private: get_in(file, ["url_private"]),
      permalink: get_in(file, ["permalink"]),
      url_private_download: get_in(file, ["url_private_download"])
    }
  end

  @doc """
  Gets the parent message ID for a threaded message.

  Returns `nil` if the message is not part of a thread or if it's the first message in the thread.
  Returns the parent message ID if it exists.
  Logs a warning if the parent message is not found.
  """
  @spec get_parent_id(%SlackEvent{}, String.t(), String.t(), String.t()) :: String.t() | nil
  def get_parent_id(%SlackEvent{} = event, event_ts, team_id, channel_record_id) do
    # thread_ts = get_in(event, ["thread_ts"]) || get_in(event, ["message", "thread_ts"])
    thread_ts = event.thread_ts || (event.event_message && event.event_message.message_thread_ts)

    if is_nil(thread_ts) or event_ts == thread_ts do
      nil
    else
      case get_unique_slack_message(thread_ts, channel_record_id, team_id) do
        nil ->
          Logger.warning("Parent message not found for thread_ts: #{thread_ts}")
          nil

        parent_channel ->
          parent_channel.id
      end
    end
  end
end
