defmodule DAUWeb.ViewExternalEscalationsLive do
  use DAUWeb, :live_view

  alias DAU.ExternalEscalation
  import DAUWeb.CoreComponents

  @cols [
    {"Organization Name", :organization_name},
    {"Submitter Name",   :submitter_name},
    {"Designation",      :submitter_designation},
    {"Email",            :submitter_email},
    {"Country",          :organization_country},
    {"Media Type",       :escalation_media_type},
    {"Language",         :content_language},
    {"Platform",         :content_platform},
    {"Media Link",       :media_link},
    {"Transcript",       :transcript},
    {"English Translation", :english_translation},
    {"Additional Info",  :additional_info},
    {"Emails for Slack", :emails_for_slack},
    {"Submitted At (IST)",     :inserted_at}
  ]

  @impl true
  def mount(_params, _session, socket) do
    entries =
      case ExternalEscalation.list_form_entries() do
        {:error, _} -> []
        other       -> other
      end

    {:ok, assign(socket, entries: entries, cols: @cols)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>External Escalation Form Entries</.header>
    <div class="w-full max-h-[80vh] overflow-auto border rounded p-5">
      <.table id="external_escalations" rows={@entries}>
        <:col
          :let={entry}
          :for={col <- @cols}
          label={elem(col, 0)}
        >
          <div class={"max-w-[16rem] min-h-[2.5rem] max-h-[10rem] overflow-auto"}>
            <%= format_cell(entry, elem(col, 1)) %>
          </div>
        </:col>
      </.table>
    </div>
    """
  end


  defp format_cell(entry, :inserted_at) do
    case entry.inserted_at do
      nil -> "N/A"
      datetime ->
        Timex.to_datetime(datetime, "Asia/Calcutta")
        |> Calendar.strftime("%d-%m-%Y %I:%M %P")
    end
  end

  defp format_cell(entry, :escalation_media_type) do
    entry.escalation_media_type
    |> List.wrap()
    |> Enum.join(", ")
  end

  defp format_cell(entry, field) do
    case Map.get(entry, field) do
      nil -> "N/A"
      v   -> to_string(v)
    end
  end
end
