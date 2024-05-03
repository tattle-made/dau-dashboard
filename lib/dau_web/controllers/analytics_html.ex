defmodule DAUWeb.AnalyticsHTML do
  use DAUWeb, :html

  def index(assigns) do
    ~H"""
    <h1>HELLO</h1>
    <ul>
      <%= for item <- @data do %>
        <li><%= item.url %></li>
      <% end %>
    </ul>
    """
  end
end
