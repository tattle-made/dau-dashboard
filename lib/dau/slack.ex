defmodule DAU.Slack do
  @moduledoc """
  Module for handling Slack-related operations including message processing,
  channel management, and event handling.
  """

  alias DAU.Repo
  alias DAU.Slack.Channel
  alias DAU.Slack.Message
  alias DAU.Slack.Event
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

  @doc """
  Processes a Slack message event based on its type (delete, edit, or new).

  Returns `{:ok, result}` on success or `{:error, reason}` on failure.
  """
  @spec process_message(map(), String.t(), String.t(), map()) :: {:ok, any()} | {:error, atom()}
  def process_message(event, event_id, team_id, payload) do
    with {:ok, _created_event} <- create_slack_event_from_event_id(event_id) do
      case get_event_type(event, team_id) do
        :delete ->
          process_message_delete(event, team_id, payload)

        :edit ->
          process_message_edit(event, team_id, payload)

        :duplicate ->
          {:ok, :duplicate_message}

        :new ->
          process_new_slack_message(event, team_id, payload)

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

  def get_event_type(event, team_id) do
    # event_type = get_in(event, ["type"])
    event_subtype = get_in(event, ["subtype"])
    event_deleted_ts = get_in(event, ["deleted_ts"])
    previous_message = get_in(event, ["previous_message"])
    # message = get_in(event, ["message"])
    message_subtype = get_in(event, ["message", "subtype"])
    message_edited = get_in(event, ["message", "edited"])

    cond do
      event_subtype == "message_deleted" or message_subtype == "tombstone" or
          !is_nil(event_deleted_ts) ->
        :delete

      !is_nil(message_edited) or !is_nil(previous_message) ->
        :edit

      check_repeated_payload?(event, team_id) ->
        :duplicate

      true ->
        :new
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

  def check_repeated_payload?(event, team_id) do
    message = get_in(event, ["message"])
    channel_id = event["channel"]

    channel =
      case get_slack_channel_from_channel_id(channel_id) do
        nil ->
          nil

        channel ->
          channel
      end

    ts =
      if is_nil(message) do
        event["ts"]
      else
        message["ts"]
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
  @spec process_message_delete(map(), String.t(), map()) :: {:ok, atom()} | {:error, atom()}
  def process_message_delete(event, team_id, _payload) do
    with message_ts when not is_nil(message_ts) <- get_in(event, ["message", "ts"]),
         event_channel_id when not is_nil(event_channel_id) <- event["channel"],
         channel when not is_nil(channel) <- get_slack_channel_from_channel_id(event_channel_id),
         ts when not is_nil(ts) <-
           message_ts || get_in(event, ["deleted_ts"]) || get_in(event, ["ts"]),
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
  Processes an edit event for an existing Slack message.

  Updates the message text, URLs, and files if they've changed.
  Returns `{:ok, :message_edit_processed}` on success or `{:error, reason}` on failure.
  """
  @spec process_message_edit(map(), String.t(), map()) :: {:ok, atom()} | {:error, atom()}
  def process_message_edit(%{"message" => message} = event, team_id, _payload) do
    with ts <- Map.get(message || %{}, "ts", event["ts"]),
         event_channel_id when not is_nil(event_channel_id) <- event["channel"],
         channel when not is_nil(channel) <- get_slack_channel_from_channel_id(event_channel_id),
         existing_message when not is_nil(existing_message) <-
           get_unique_slack_message(ts, channel.id, team_id) do
      text = get_in(message, ["text"])
      urls = get_message_urls(event)
      files = get_message_files(event)

      existing_message = get_unique_slack_message(ts, channel.id, team_id)

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

  def process_new_slack_message(event, team_id, _payload) do
    with {:ok, %{"channel" => channel_id, "ts" => ts, "user" => user, "text" => text} = _event} <-
           validate_message_event(event),
         {:ok, channel} <- get_or_create_channel(channel_id) do
      Logger.debug("Processing new message from user #{user} in channel #{channel_id}")

      message_attrs = %{
        ts: ts,
        team: team_id,
        user: user,
        text: text,
        urls: get_message_urls(event),
        channel_id: channel.id,
        parent_id: get_parent_id(event, ts, team_id, channel.id),
        files: get_message_files(event)
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

  @doc false
  @spec validate_message_event(map()) :: {:ok, map()} | {:error, atom()}
  defp validate_message_event(%{"channel" => _, "ts" => _, "user" => _, "text" => _} = event) do
    {:ok, event}
  end

  defp validate_message_event(_event) do
    Logger.warning("Invalid message event: missing required fields")
    {:error, :invalid_message_event}
  end

  @doc false
  @spec get_or_create_channel(String.t()) :: {:ok, Channel.t()} | {:error, any()}
  defp get_or_create_channel(channel_id) do
    case get_slack_channel_from_channel_id(channel_id) do
      nil ->
        case create_slack_channel(%{channel_id: channel_id}) do
          {:ok, channel} ->
            # Update channel details asynchronously
            Task.start(fn ->
              Logger.debug("Updating details for new channel: #{channel_id}")
              get_and_update_channel_details(channel_id, channel)
            end)

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
  @spec get_parent_id(map(), String.t(), String.t(), String.t()) :: String.t() | nil
  def get_parent_id(event, event_ts, team_id, channel_record_id) do
    thread_ts = get_in(event, ["thread_ts"]) || get_in(event, ["message", "thread_ts"])

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
