defmodule DAUWeb.ViewExternalEscalationsLive do
  use DAUWeb, :live_view

  alias DAU.ExternalEscalation
  import DAUWeb.CoreComponents

  @impl true
  def mount(_params, _session, socket) do
    case ExternalEscalation.list_form_entries() do
      {:error, _reason} ->
        {:ok,
         socket
         |> assign(entries: [])
         |> put_flash(:error, "Could not load escalation entries. Please try again later.")}
      entries ->
        sorted_entries = Enum.sort_by(entries, & &1.inserted_at, {:desc, DateTime})
        {:ok, assign(socket, entries: sorted_entries)}
    end
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.header>External Escalation Form Entries</.header>
    <div class="w-full max-h-[80vh] overflow-auto border rounded p-5 ">
      <.table id="external_escalations" rows={@entries}>
        <:col :let={entry} label="Organization Name">
          <div class="max-w-[12rem] min-h-[2.5rem] max-h-[8rem] overflow-y-auto" title={entry.organization_name}><%= entry.organization_name %></div>
        </:col>
        <:col :let={entry} label="Submitter Name">
          <div class="max-w-[10rem] min-h-[2.5rem] max-h-[8rem] overflow-y-auto" title={entry.submitter_name}><%= entry.submitter_name %></div>
        </:col>
        <:col :let={entry} label="Designation">
          <div class="max-w-[8rem] min-h-[2.5rem] max-h-[8rem] overflow-y-auto" title={entry.submitter_designation}><%= entry.submitter_designation %></div>
        </:col>
        <:col :let={entry} label="Email">
          <div class="max-w-[12rem] min-h-[2.5rem] max-h-[8rem] overflow-y-auto" title={entry.submitter_email}><%= entry.submitter_email %></div>
        </:col>
        <:col :let={entry} label="Country">
          <div class="max-w-[8rem] min-h-[2.5rem] max-h-[8rem] overflow-y-auto" title={entry.organization_country}><%= entry.organization_country %></div>
        </:col>
        <:col :let={entry} label="Media Type">
          <div class="max-w-[8rem] min-h-[2.5rem] max-h-[8rem] overflow-y-auto" title={Enum.join(List.wrap(entry.escalation_media_type), ", ")}><%= Enum.join(List.wrap(entry.escalation_media_type), ", ") %></div>
        </:col>
        <:col :let={entry} label="Language">
          <div class="max-w-[10rem] min-h-[2.5rem] max-h-[8rem] overflow-y-auto" title={entry.content_language}><%= entry.content_language %></div>
        </:col>
        <:col :let={entry} label="Platform">
          <div class="max-w-[8rem] min-h-[2.5rem] max-h-[8rem] overflow-y-auto" title={entry.content_platform}><%= entry.content_platform %></div>
        </:col>
        <:col :let={entry} label="Media Link">
          <div class="max-w-[16rem] min-h-[2.5rem] max-h-[8rem] overflow-x-auto overflow-y-auto" title={entry.media_link}><%= entry.media_link %></div>
        </:col>
        <:col :let={entry} label="Transcript">
          <div class="w-[16rem] min-h-[2.5rem] max-h-[8rem] overflow-x-auto overflow-y-auto" title={entry.transcript}><%= entry.transcript %></div>
        </:col>
        <:col :let={entry} label="English Translation">
          <div class="w-[16rem] min-h-[2.5rem] max-h-[8rem] overflow-x-auto overflow-y-auto" title={entry.english_translation}><%= entry.english_translation %></div>
        </:col>
        <:col :let={entry} label="Additional Info">
          <div class="w-[16rem] min-h-[2.5rem] max-h-[8rem] overflow-x-auto overflow-y-auto" title={entry.additional_info}><%= entry.additional_info %></div>
        </:col>
        <:col :let={entry} label="Emails for Slack">
          <div class="max-w-[16rem] min-h-[2.5rem] max-h-[8rem] overflow-x-auto overflow-y-auto" title={entry.emails_for_slack}><%= entry.emails_for_slack %></div>
        </:col>
        <:col :let={entry} label="Submitted At">
          <div class="max-w-[10rem] min-h-[2.5rem] max-h-[8rem] overflow-y-auto" title={to_string(entry.inserted_at)}><%= entry.inserted_at %></div>
        </:col>
      </.table>
    </div>
    """
  end
end
