defmodule DAUWeb.AnalyticsHTML do
  use DAUWeb, :html
  import DAUWeb.CoreComponents

  def index(assigns) do
    ~H"""
    <div class="flex justify-center">
      <div class="w-full max-w-4xl mx-auto">
        <div class="mb-4">
          <a href={~p"/analytics/user-registrations"} class="text-blue-600 hover:underline">
            User registrations
          </a>
        </div>

        <.table id="analytics-table" rows={@data}>
          <:col :let={item} label="Username">
            {item.username}
          </:col>

          <:col :let={item} label="Factcheck Articles Added">
            {item.url_count}
          </:col>
        </.table>
      </div>
    </div>
    """
  end

  def user_registrations(assigns) do
    ~H"""
    <div class="p-6">
      <h1 class="text-2xl font-bold mb-4">
        User registrations
      </h1>

      <.table id="user-registrations" rows={@users}>
        <:col :let={user} label="Email">
          {user.email}
        </:col>

        <:col :let={user} label="Role">
          {user.role}
        </:col>

        <:col :let={user} label="Registered At">
          {user.inserted_at}
        </:col>
      </.table>

      <div class="mt-6 flex items-center gap-4">
        <%= if @page > 1 do %>
          <a
            href={~p"/analytics/user-registrations?page=#{@page - 1}"}
            class="text-blue-600 hover:underline"
          >
            ← Previous
          </a>
        <% end %>

        <span class="font-medium">
          Page {@page}
        </span>

        <%= if @page * 20 < @total_users do %>
          <a
            href={~p"/analytics/user-registrations?page=#{@page + 1}"}
            class="text-blue-600 hover:underline"
          >
            Next →
          </a>
        <% end %>
      </div>
    </div>
    """
  end
end
