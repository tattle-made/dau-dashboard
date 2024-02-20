defmodule DAUWeb.ResponseLive.FormComponent do
  use DAUWeb, :live_component

  alias DAU.Verification

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage response records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="response-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >

        <:actions>
          <.button phx-disable-with="Saving...">Save Response</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{response: response} = assigns, socket) do
    changeset = Verification.change_response(response)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"response" => response_params}, socket) do
    changeset =
      socket.assigns.response
      |> Verification.change_response(response_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"response" => response_params}, socket) do
    save_response(socket, socket.assigns.action, response_params)
  end

  defp save_response(socket, :edit, response_params) do
    case Verification.update_response(socket.assigns.response, response_params) do
      {:ok, response} ->
        notify_parent({:saved, response})

        {:noreply,
         socket
         |> put_flash(:info, "Response updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_response(socket, :new, response_params) do
    case Verification.create_response(response_params) do
      {:ok, response} ->
        notify_parent({:saved, response})

        {:noreply,
         socket
         |> put_flash(:info, "Response created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
