defmodule DAUWeb.QueryHTML do
  use DAUWeb, :html
  import DAUWeb.CoreComponents

  def index(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="w-full max-w-4xl mx-auto">
        <.table id="query-table" rows={@data}>
          <:col :let={item} label="Sender Name">
            <%= item.messages |> hd |> Map.get(:sender_name) %>
          </:col>
          <:col :let={item} label="Sender Number">
            <%= item.messages |> hd |> Map.get(:sender_number) %>
          </:col>
          <:col :let={item} label="Sender Number">
            <%= item.messages |> hd |> Map.get(:user_language_input) %>
          </:col>
        </.table>
      </div>
    </div>
    """
  end
end
