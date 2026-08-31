defmodule DAUWeb.AnalyticsHTML do
  use DAUWeb, :html
  import DAUWeb.CoreComponents

  def index(assigns) do
  ~H"""
  <div class="flex justify-center">
    <div class="w-full max-w-4xl mx-auto">

      <div class="mb-4">
        <a
          href={~p"/analytics/user-registrations"}
          class="text-blue-600 hover:underline"
        >
          User registrations
        </a>
      </div>

      <.table id="analytics-table" rows={@data}>
        <:col :let={item} label="Username"><%= item.username %></:col>
        <:col :let={item} label="Factcheck Articles Added"><%= item.url_count %></:col>
      </.table>

    </div>
  </div>
  """
end

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

  def user_registrations(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold">User registrations</h1>
      <p>Coming soon...</p>
    </div>
    """
  end
end
