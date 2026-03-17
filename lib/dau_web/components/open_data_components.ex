defmodule DAUWeb.Components.OpenDataComponents do
  use Phoenix.Component
  import DAUWeb.CoreComponents
  import Phoenix.HTML, only: [raw: 1]

  @doc ~S"""
  Same as the above Table component. Customized for feed open table

  ## Examples

      <.table id="users" rows={@users}>
        <:col :let={user} label="id"><%= user.id %></:col>
        <:col :let={user} label="username"><%= user.username %></:col>
      </.table>
  """
  attr :id, :string, required: true
  attr :rows, :list, required: true
  attr :row_id, :any, default: nil, doc: "the function for generating the row id"
  attr :row_click, :any, default: nil, doc: "the function for handling phx-click on each row"

  attr :row_item, :any,
    default: &Function.identity/1,
    doc: "the function for mapping each row before calling the :col and :action slots"

  slot :col, required: true do
    attr :label, :string
  end

  slot :action, doc: "the slot for showing user actions in the last table column"

  def feed_open_table(assigns) do
    assigns =
      with %{rows: %Phoenix.LiveView.LiveStream{}} <- assigns do
        assign(assigns, row_id: assigns.row_id || fn {id, _item} -> id end)
      end

    ~H"""
    <div class="w-full max-w-full min-w-0">
      <div class="w-full max-w-full overflow-x-auto overflow-y-auto max-h-[72vh] rounded-lg border border-zinc-200 bg-white">
        <table class="min-w-full text-sm table-fixed">
          <thead class="sticky top-0 z-10 bg-white text-left leading-6 text-zinc-500">
            <tr>
              <th :for={col <- @col} class="px-3 py-2 font-medium"><%= col[:label] %></th>
              <th :if={@action != []} class="px-3 py-2">
                <span class="sr-only">Actions</span>
              </th>
            </tr>
          </thead>
          <tbody
            id={@id}
            phx-update={match?(%Phoenix.LiveView.LiveStream{}, @rows) && "stream"}
            class="divide-y divide-zinc-200 border-t border-zinc-200 leading-6 text-zinc-700"
          >
            <tr :for={row <- @rows} id={@row_id && @row_id.(row)} class="hover:bg-zinc-50">
              <td
                :for={{col, i} <- Enum.with_index(@col)}
                phx-click={@row_click && @row_click.(row)}
                class={["px-3 py-2 align-top", @row_click && "hover:cursor-pointer"]}
              >
                <div class={["min-w-0", i == 0 && "font-semibold text-zinc-900"]}>
                  <%= render_slot(col, @row_item.(row)) %>
                </div>
              </td>
              <td :if={@action != []} class="w-14 px-3 py-2 align-top">
                <div class="whitespace-nowrap text-right text-sm font-medium">
                  <span
                    :for={action <- @action}
                    class="ml-4 font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
                  >
                    <%= render_slot(action, @row_item.(row)) %>
                  </span>
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>
    """
  end

  @doc """
  reated from queryt component of core-components

  ## Examples
    <.render_preview type="image" url="https://path-to-media" />
    <.render_preview type="video" url="https://path-to-media" />
  """

  attr :type, :string, required: true
  attr :url, :string, required: true

  def render_preview(assigns) do
    ~H"""
    <div class="flex flex-row gap-1 max-h-48 ">
      <div class="">
        <%= if (@type=="image" or @type=="video") and not is_nil(@url) do %>
          <div class="w-24 max-h-48 overflow-hidden">
            <img src={@url} />
          </div>
        <% end %>
        <%!-- <%= if @type=="video" do %>
          <video class="w-24" controls>
            <source src={@url} type="video/mp4" />
          </video>
        <% end %> --%>
        <%= if @type=="audio" and not is_nil(@url) do %>
          <audio class="w-64" controls>
            <source src={@url} />
          </audio>
        <% end %>
        <%= if @type=="text" do %>
          <div class="w-48 h-full overflow-hidden">
           <%= if is_nil(@url) do %>
             <p>-</p>
           <% else %>
             <p class="text-blue-500 break-words whitespace-normal max-w-[12rem]">
               <%= String.slice(@url, 0..30) %>...
             </p>
           <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end


end
