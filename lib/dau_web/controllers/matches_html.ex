defmodule DAUWeb.MatchesHTML do
  use DAUWeb, :html
  import DAUWeb.CoreComponents

  def index(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="w-full max-w-4xl mx-auto">
        <.table id="query-table" rows={@matches.result}>
          <:col :let={item} label="Query ID">
            <.link
              navigate={~p"/demo/query/#{item.feed_id}/"}
              class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
            >
              <%= item.feed_id %>
            </.link>
          </:col>
          <:col :let={item} label="Language">
            <%= item.language %>
          </:col>
          <:col :let={item} label="Response">
            <%= item.response %>
            <%!-- <%= item.messages |> hd |> Map.get(:sender_number) %> --%>
          </:col>

          <:col :let={item} label="Response">
            <.link
              href={~p"/demo/query/import-response/src/#{item.feed_id}/target/#{@src}"}
              method="post"
            >
              Import Response
            </.link>
          </:col>

          <%!-- <:col :let={item} label="Sender Number">
            <%= item.messages |> hd |> Map.get(:user_language_input) %>
          </:col> --%>
        </.table>
      </div>
    </div>
    """
  end
end
