defmodule DAUWeb.UserConfirmationLandingLive do
  use DAUWeb, :live_view
  alias DAUWeb.UserAuth
  alias DAU.Accounts.User

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1 class="text-4xl text-center font-bold text-brand">Welcome to DAU!</h1>
    <h2 class="text-xl text-center font-bold mt-8 text-gray-400">Email Confirmation</h2>
    <div class="mt-5 text-center">
      <p class="">
        <%= if @reason == "resend" do %>
          If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly.
        <% else %>
          A confirmation email has been sent to your registered email address. Please check your inbox and follow the instructions to confirm your email.
        <% end %>
      </p>
      <p>
        If you didn’t receive a confirmation email or if your confirmation link has expired, click
        <.link navigate={~p"/users/confirm"} class="text-blue-500 underline">here</.link>
        to resend it.
      </p>
    </div>
    """
  end

  @impl Phoenix.LiveView
  def mount(params, _session, socket) do
    case socket.assigns[:current_user] do
      %User{confirmed_at: confirmed_at} = user when not is_nil(confirmed_at) ->
        {:ok, redirect(socket, to: UserAuth.signed_in_path_for(user))}

      _ ->
        reason = Map.get(params, "reason")
        {:ok, assign(socket, reason: reason)}
    end
  end
end
