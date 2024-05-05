defmodule DAUWeb.AnalyticsHTML do
  use DAUWeb, :html
  import DAUWeb.CoreComponents

  def index(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="w-full max-w-4xl mx-auto">
        <.table id="analytics-table" rows={@data}>
          <:col :let={item} label="Username"><%= item.username %></:col>
          <:col :let={item} label="Factcheck Articles Added"><%= item.url_count %></:col>
        </.table>
      </div>
    </div>
    """
  end
end
