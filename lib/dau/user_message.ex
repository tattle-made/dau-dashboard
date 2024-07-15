defmodule DAU.UserMessage do
  @moduledoc """
  The UserMessage context.
  """

  import Ecto.Query, warn: false
  require Logger
  require Logger
  alias DAU.UserMessage.Outbox
  alias DAU.UserMessage.MessageDelivery
  alias DAU.Accounts.User
  alias DAU.UserMessage
  alias DAU.Feed.Common
  alias DAU.UserMessage.Query
  alias DAU.UserMessage.Preference
  alias DAU.Repo
  alias DAU.UserMessage.Inbox

  # alias Ecto.Multi

  @doc """
  Returns the list of incoming_messages.

  ## Examples

      iex> list_incoming_messages()
      [%IncomingMessage{}, ...]

  """
  def list_incoming_messages do
    Repo.all(Inbox)
  end

  @doc """
  Gets a single incoming_message.

  Raises `Ecto.NoResultsError` if the Incoming message does not exist.

  ## Examples

      iex> get_incoming_message!(123)
      %IncomingMessage{}

      iex> get_incoming_message!(456)
      ** (Ecto.NoResultsError)

  """
  def get_incoming_message!(id), do: Repo.get!(Inbox, id)

  def get_incoming_message(id), do: Repo.get(Inbox, id)

  @doc """
  Creates a incoming_message.

  ## Examples

      iex> create_incoming_message(%{field: value})
      {:ok, %IncomingMessage{}}

      iex> create_incoming_message(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_incoming_message(attrs \\ %{}) do
    %Inbox{}
    |> Inbox.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Creates a incoming_message since v0.3.0

  Till 0.3.0, user messages were added to inbox and directly to feed_common.
  Inbox messages are now grouped into queries and added to a queue to be processed by a Feluda worker.
  When a response comes from the worker, only then they are added to common.
  """
  def create_incoming_message(:queue, attrs) do
    with {:ok, inbox} <- create_inbox(attrs),
         {:ok, inbox_with_query} <- associate_inbox_to_query(inbox) do
      {:ok, inbox_with_query}
    else
      err ->
        Logger.error("Could not create incoming message. #{inspect(err)}")

        Sentry.capture_message("Could not create incoming message %s",
          interpolation_parameters: ["#{inspect(err)}"]
        )

        {:error, "Unexpected error in creating incoming message. #{inspect(err)}"}
    end
  rescue
    err ->
      Logger.error("Could not create incoming message. #{inspect(err)}")
      {:error, "Unexpected error in creating incoming message. #{inspect(err)}"}
  end

  def create_inbox(attrs) do
    %Inbox{} |> Inbox.changeset(attrs) |> Repo.insert()
  end

  def create_query(atrs)

  @doc """
  This is used only for testing purposes. It allows us to set inserted_at and updated_at timestamps.
  This is NOT to be used in application code.
  """
  def create_incoming_message_with_date(attrs \\ %{}) do
    %Inbox{}
    |> Inbox.changeset_with_date(attrs)
    |> Repo.insert()
  end

  def associate_inbox_to_query(%Inbox{} = inbox) do
    with {:ok, query} <- %Query{} |> Query.changeset() |> Repo.insert(),
         preloaded_inbox <- Repo.get(Inbox, inbox.id) |> Repo.preload(:query),
         {:ok, updated_inbox} <- associate_inbox_to_query(preloaded_inbox, query) do
      {:ok, updated_inbox}
    else
      _ -> {:error, "Could not associate inbox to query"}
    end
  end

  def associate_inbox_to_query(%Inbox{} = inbox_message, %Query{} = query) do
    inbox_message
    |> Inbox.associate_query_changeset(query)
    |> Repo.update()
  end

  def associate_inbox_to_query(inbox_id, %Query{} = query) do
    Repo.get(Inbox, inbox_id)
    |> Repo.preload(:query)
    |> Inbox.associate_query_changeset(query)
    |> Repo.update()
  end

  @doc """
  Updates a incoming_message.

  ## Examples

      iex> update_incoming_message(incoming_message, %{field: new_value})
      {:ok, %IncomingMessage{}}

      iex> update_incoming_message(incoming_message, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_inbox_message(%Inbox{} = inbox_message, attrs) do
    inbox_message
    |> Inbox.changeset(attrs)
    |> Repo.update()
  end

  def update_user_message_file_metadata(%Inbox{} = inbox_message, attrs) do
    inbox_message
    |> Inbox.file_metadata_changeset(attrs)
    |> Repo.update()
  end

  def update_user_message_text_file_hash(%Inbox{} = inbox_message, attrs) do
    inbox_message
    |> Inbox.text_file_hash_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a incoming_message.

  ## Examples

      iex> delete_incoming_message(incoming_message)
      {:ok, %IncomingMessage{}}

      iex> delete_incoming_message(incoming_message)
      {:error, %Ecto.Changeset{}}

  """
  def delete_incoming_message(%Inbox{} = incoming_message) do
    Repo.delete(incoming_message)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking incoming_message changes.

  ## Examples

      iex> change_incoming_message(incoming_message)
      %Ecto.Changeset{data: %IncomingMessage{}}

  """
  def change_incoming_message(%Inbox{} = incoming_message, attrs \\ %{}) do
    Inbox.changeset(incoming_message, attrs)
  end

  def get_user_preference(payload) do
    changeset =
      %Preference{}
      |> Preference.phone_changeset(payload)

    if changeset.valid? == true do
      Repo.get_by(Preference, sender_number: changeset.data.sender_number)
    else
      {:error}
    end
  end

  def create_query(attrs \\ %{}) do
    %Query{}
    |> Query.changeset(attrs)
    |> Repo.insert()
  end

  def create_query_with_common(common, attrs \\ %{}) do
    %Query{}
    |> Query.changeset(attrs)
    |> Query.feed_common_changeset(common)
    |> Repo.insert()
  end

  def create_outbox(attrs \\ %{}) do
    %Outbox{}
    |> Outbox.changeset(attrs)
    |> Repo.insert()
  end

  def add_outbox_to_query(query, outbox) do
    result =
      Repo.get!(Query, query.id)
      |> Repo.preload(:user_message_outbox)

    Query.associate_outbox(result, outbox)
    |> Repo.update()
  end

  @doc """

  todo :
  use `inner_lateral_join` to limit the number of associations fetched.
  This could be an issue when there's a lot of data.
  """
  def add_response_to_outbox(%Common{} = common) do
    result =
      Repo.get!(Common, common.id)
      |> Repo.preload(query: [:user_message_outbox])

    if result.query != nil do
      # raise "Unexpected state"
      response = %{
        sender_number: common.sender_number,
        reply_type: Query.reply_type(result.query),
        type: "text",
        text: common.user_response
      }

      {:ok, outbox} =
        UserMessage.create_outbox(response)

      UserMessage.add_outbox_to_query(result.query, outbox)
    else
      {:ok, query} =
        UserMessage.create_query_with_common(result, %{
          status: "pending",
          inserted_at: common.inserted_at
        })

      response = %{
        sender_number: common.sender_number,
        reply_type: Query.reply_type(query),
        type: "text",
        text: common.user_response
      }

      {:ok, outbox} =
        UserMessage.create_outbox(response)

      UserMessage.add_outbox_to_query(query, outbox)
    end
  end

  def approve_message_in_outbox(%Outbox{} = outbox, %User{} = user) do
    if Permission.has_privilege?(user, :approve, Outbox) do
      result =
        Repo.get!(Outbox, outbox.id)
        |> Repo.preload(:approver)

      result
      |> Outbox.approver_changeset(user)
      |> Repo.update()
    else
      raise PermissionException
    end
  end

  def add_delivery_report(id, delivery_report) do
    outbox =
      Repo.get(Outbox, id)
      |> Outbox.delivery_report_changeset(delivery_report)
      |> Repo.update()

    outbox
  end

  def add_e_id(txn_id, msg_id) do
    Repo.get(Outbox, msg_id)
    |> Outbox.e_id_changeset(%{e_id: txn_id})
    |> Repo.update()
  end

  def list_queries(feed_common_id) do
    Repo.get_by(Query, feed_common_id: feed_common_id)
    |> Repo.preload(:user_message_outbox)
  end

  def list_outbox(page_num \\ 0) do
    Query
    |> limit(25)
    |> offset(25 * ^page_num)
    |> order_by(desc: :inserted_at)
    |> where([q], not is_nil(q.user_message_outbox_id))
    |> Repo.all()
    |> Repo.preload(:user_message_outbox)
  end

  def send_response(%Outbox{id: id}) do
    outbox = Repo.get(Outbox, id)

    reply_function =
      case outbox.reply_type do
        :customer_reply -> &MessageDelivery.client().send_message_to_bsp/3
        :notification -> &MessageDelivery.client().send_template_to_bsp/3
      end

    case reply_function.(outbox.id, outbox.sender_number, outbox.text) do
      {:ok, %HTTPoison.Response{} = response} ->
        Logger.info(response.body)

        case Outbox.parse_bsp_status_response(response.body) do
          {:ok, {txn_id, msg_id}} ->
            case UserMessage.add_e_id(txn_id, msg_id) do
              {:ok, _} ->
                {:ok}

              {:error, reason} ->
                Logger.error(reason)
                {:error, "Unable to update e_id"}
            end

          {:error, reason} ->
            Logger.error(reason)
            {:error, "Unable to update status in database"}
        end

      {:error, reason} ->
        Logger.error(reason)
        {:error, "Error with BSP"}
    end
  end

  def add_query_to_feed(%Query{} = query, %Common{} = common) do
    Query.associate_feed_common_changeset(query, common)
    |> Repo.update()
  end
end
