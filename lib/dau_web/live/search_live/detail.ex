defmodule DAUWeb.SearchLive.Detail do
  alias DAU.Feed.Resource
  alias DAU.Accounts
  alias DAU.Feed.Common
  alias DAU.Feed
  alias Permission
  use DAUWeb, :live_view
  use DAUWeb, :html

  def mount(_params, session, socket) do
    user_token = session["user_token"]
    user = user_token && Accounts.get_user_by_session_token(user_token)

    query = ""

    socket =
      socket
      |> assign(:query, query)
      |> assign(:current_user, user)
      |> assign(:current_user_name, String.split(user.email, "@") |> hd)

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    query = Feed.get_feed_item_by_id(id)

    socket =
      socket
      |> assign(:query, query)
      |> stream(:resources, query.resources)

    {:noreply, socket}
  end

  # def handle_event(event, unsigned_params, socket) do
  # end

  def handle_event("test-click", value, socket) do
    query = socket.assigns.query <> value["value"]
    {:noreply, assign(socket, :query, query)}
  end

  def handle_event("send-to-user", %{"assessment-report" => assessment_report}, socket) do
    query_id = socket.assigns.query.id
    Feed.send_assessment_report_to_user(query_id, assessment_report)

    socket =
      socket
      |> put_flash(:info, "Assessment report has been sent to user")

    {:noreply, socket}
  end

  def handle_event("save-verification-sop", verification_sop_params, socket) do
    case Feed.add_verification_sop(socket.assigns.query, verification_sop_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Verification SOP saved")}

      {:error, %Ecto.Changeset{} = changeset} ->
        IO.inspect(changeset)

        {:noreply,
         socket
         |> put_flash(:error, "Error saving verification SOP")}
    end
  end

  def handle_event("add-resource", params, socket) do
    IO.inspect(params)

    resource = %Resource{
      username: socket.assigns.current_user_name,
      type: "text",
      text: params["resource-text"]
    }

    {:ok, query} = Feed.add_resource(socket.assigns.query.id, resource)

    {:noreply, socket |> assign(:query, query)}
  end

  defp get_default_user_response_message(%Common{} = query) do
    case query.user_response do
      nil ->
        """
        📢 We reviewed this #{query.media_type || ""} and found it to be #{query.verification_status || "<awaiting verification status>"}.

        🎯You can read our assessment report here: <insert link>

        Fact checkers have also shared the following:

        1. <Fact checker name>: <Headline><link>

        2. <Fact checker name>: <Headline><link>

        3. <Fact checker name>: <Headline><link>

        🧠  Please use your thoughtful discretion in sharing this forward.

        Thank you reaching out to use. We hope you have a good day ahead. 🙏
        """

      _ ->
        query.user_response
    end
  end
end
