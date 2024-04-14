defmodule DAUWeb.SearchLive.Detail do
  alias DAU.UserMessage
  alias DAU.UserMessage.Templates.Factory
  alias DAU.UserMessage.Templates.Template
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

  # def handle_event("send-to-user", %{"assessment-report" => assessment_report}, socket) do
  #   query_id = socket.assigns.query.id
  #   Feed.send_assessment_report_to_user(query_id, assessment_report)

  #   socket =
  #     socket
  #     |> put_flash(:info, "Assessment report has been sent to user")

  #   {:noreply, socket}
  # end

  def handle_event("approve-response", _param, socket) do
    query = socket.assigns.query
    response = get_templatized_response(query)
    Feed.add_user_response(query.id, response)
    common = Feed.get_feed_item_by_id(query.id)
    # Feed.send_assessment_report_to_user(query_id, assessment_report)
    socket =
      case UserMessage.add_response_to_outbox(common) do
        {:ok, query} ->
          query = Feed.get_feed_item_by_id(query.id)

          socket
          |> put_flash(:info, "Response Approved")
          |> assign(:query, query)

        {:error, _reason} ->
          socket
          |> put_flash(:info, "Error caused while approving response. Please reach out to admin")
      end

    # common = Feed.get_feed_item_by_id(query.id)

    # {:noreply, assign(socket, :query, common)}
    {:noreply, socket}
  end

  def handle_event("save-verification-sop", verification_sop_params, socket) do
    case Feed.add_verification_sop(socket.assigns.query, verification_sop_params) do
      {:ok, query} ->
        {:noreply,
         socket
         |> put_flash(:info, "Verification SOP saved")
         |> assign(:query, query)}

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

  def handle_event("change-status-factheck-article", params, socket) do
    query_id = socket.assigns.query.id
    article_id = params["value"]

    server_response =
      case params["type"] do
        "reject" -> Feed.set_approval_status(query_id, article_id, false)
        "approve" -> Feed.set_approval_status(query_id, article_id, true)
      end

    socket =
      case server_response do
        {:ok, query} ->
          socket |> assign(:query, query)

        {:error, reason} ->
          socket
          |> put_flash(:error, reason)
      end

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
        {:ok, query} ->
          socket |> put_flash(:info, "user response label applied") |> assign(:query, query)

        {:error, %Ecto.Changeset{} = changeset} ->
          socket |> assign(:form_user_response_label, to_form(changeset))
      end

    {:noreply, socket}
  end

  # defp get_default_user_response_message(%Common{} = query) do
  #   if query.user_response do
  #     query.user_response
  #   else
  #     UserResponseTemplate.get_text(query)
  #   end
  # end

  def get_templatized_response(%Common{} = query) do
    %Template{meta: meta} = template = query |> Factory.process()

    text =
      case meta.valid do
        true ->
          case Factory.eval(template) do
            {:ok, text} -> text
            {:error, reason} -> reason
          end

        false ->
          "No matching template found yet"
      end

    text
  end

  defp sop_text(%Common{} = query) do
    default_text = """
    Identify claim or hoax\n
    Confirm it is fact checkable\n
    Choose what you will focus on\n
    Find the fact\n
    Correct the record\n
    """

    sop =
      case query.verification_sop do
        nil -> default_text
        _ -> query.verification_sop
      end

    # sop = Map.get(query, :verification_sop, default_text)
    IO.inspect(sop)
  end

  def beautify_url(url) when is_binary(url) do
    case String.length(url) do
      x when x > 40 -> String.slice(url, 0..20) <> "..." <> String.slice(url, -20..-1)
      x when x < 40 -> url
    end
  end
end
