defmodule DAU.UserMessage do
  @moduledoc """
  The UserMessage context.
  """

  import Ecto.Query, warn: false
  alias DAU.UserMessage.Preference
  alias DAU.Repo

  alias DAU.UserMessage.Inbox

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
end
