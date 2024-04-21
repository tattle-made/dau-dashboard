defmodule DAUWeb.UserMessagePreferenceController do
  alias DAU.UserMessage
  alias DAU.UserMessage.Preference
  alias DAU.Repo
  use DAUWeb, :controller

  action_fallback DAUWeb.FallbackController

  def create(conn, payload) do
    changeset =
      %Preference{}
      |> Preference.changeset(payload)

    if changeset.valid? == true do
      case Repo.get(Preference, changeset.data.sender_number) do
        {:ok, _sender_preference} -> changeset |> Repo.update()
        nil -> changeset |> Repo.insert()
      end
    end

    conn
    |> Plug.Conn.send_resp(200, [])
  end

  def fetch(conn, payload) do
    case UserMessage.get_user_preference(payload) do
      {:ok, user_preference} ->
        render(conn, :show, preference: user_preference)

      {:error} ->
        conn
        |> Plug.Conn.send_resp(500, [])
    end
  end
end
