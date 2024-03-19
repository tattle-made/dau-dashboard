defmodule DAUWeb.SearchLive.Detail do
  alias DAU.Feed.AssessmentReport
  alias DAU.Feed.FactcheckArticle
  alias DAUWeb.SearchLive.UserResponseTemplate
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

    form_user_response_label = %Common{} |> Common.user_response_changeset() |> to_form()

    socket =
      socket
      |> assign(:query, query)
      |> assign(:form_user_response_label, form_user_response_label)
      |> assign(:current_user, user)
      |> assign(:current_user_name, String.split(user.email, "@") |> hd)

    {:ok, socket}
  end

  def handle_params(%{"id" => id}, _uri, socket) do
    query = Feed.get_feed_item_by_id(id)
    form_user_response_label = query |> Common.user_response_changeset() |> to_form()

    socket =
      socket
      |> assign(:query, query)
      |> assign(:form_user_response_label, form_user_response_label)
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

  def handle_event("add-factcheck-article", params, socket) do
    IO.inspect(params)

    factcheck_article = %FactcheckArticle{
      username: socket.assigns.current_user_name,
      url: params["factcheck-article-url"]
    }

    {:ok, query} = Feed.add_factcheck_article(socket.assigns.query.id, factcheck_article)

    socket = socket |> assign(:query, query)

    {:noreply, socket}
  end

  def handle_event("add-assessment-report", params, socket) do
    IO.inspect(params)

    assessment_report = %AssessmentReport{
      url: params["assessment-report-url"]
    }

    {:ok, query} = Feed.add_assessment_report(socket.assigns.query.id, assessment_report)
    socket = socket |> assign(:query, query)

    {:noreply, socket}
  end

  def handle_event("save-user-response-label", %{"common" => common}, socket) do
    query = socket.assigns.query

    socket =
      case Feed.add_user_response_label(query, common) do
        {:ok, _} ->
          socket |> put_flash(:info, "user response label applied")

        {:error, %Ecto.Changeset{} = changeset} ->
          socket |> assign(:form_user_response_label, to_form(changeset))
      end

    {:noreply, socket}
  end

  defp get_default_user_response_message(%Common{} = query) do
    UserResponseTemplate.get_text(query)
  end
end
