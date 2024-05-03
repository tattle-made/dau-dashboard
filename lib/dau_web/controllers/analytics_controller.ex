defmodule DAUWeb.AnalyticsController do
  use DAUWeb, :controller
  # use DAUWeb, :html
  alias DAU.Analytics

  def hello_world(conn, _params) do
    # text(conn, "OK")
    data = Analytics.fetch_author_and_url()
    IO.inspect(data)
    # urls = Enum.map(data, & &1.url)
    # header_text = "HERE ARE THE URLS"
    render(conn, :index, data: data)
  end
end

# <h1><%= @header_text %></h1>
# <ul>
#     <%= for url <- @urls do %>
#         <li><%= url %></li>
#     <% end %>
# </ul>
