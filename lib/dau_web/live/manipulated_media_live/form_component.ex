defmodule DAUWeb.ManipulatedMediaLive.FormComponent do
  use DAUWeb, :live_component

  alias DAU.Canon

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage manipulated_media records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="manipulated_media-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:description]} type="text" label="Description" />
        <.input field={@form[:url]} type="text" label="Url" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Manipulated media</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{manipulated_media: manipulated_media} = assigns, socket) do
    changeset = Canon.change_manipulated_media(manipulated_media)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"manipulated_media" => manipulated_media_params}, socket) do
    changeset =
      socket.assigns.manipulated_media
      |> Canon.change_manipulated_media(manipulated_media_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"manipulated_media" => manipulated_media_params}, socket) do
    save_manipulated_media(socket, socket.assigns.action, manipulated_media_params)
  end

  defp save_manipulated_media(socket, :edit, manipulated_media_params) do
    case Canon.update_manipulated_media(socket.assigns.manipulated_media, manipulated_media_params) do
      {:ok, manipulated_media} ->
        notify_parent({:saved, manipulated_media})

        {:noreply,
         socket
         |> put_flash(:info, "Manipulated media updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_manipulated_media(socket, :new, manipulated_media_params) do
    case Canon.create_manipulated_media(manipulated_media_params) do
      {:ok, manipulated_media} ->
        notify_parent({:saved, manipulated_media})

        {:noreply,
         socket
         |> put_flash(:info, "Manipulated media created successfully")
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
