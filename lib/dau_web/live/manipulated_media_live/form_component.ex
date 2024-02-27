defmodule DAUWeb.ManipulatedMediaLive.FormComponent do
  use DAUWeb, :live_component

  alias DAU.Canon
  alias DAUWeb.ManipulatedMediaLive.SimpleS3Upload

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
        <div class="container" phx-drop-target={@uploads.manipulated_media.ref}>
          <.live_file_input upload={@uploads.manipulated_media} />
        </div>
        <.input field={@form[:description]} type="text" label="Description" />
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
     |> assign_form(changeset)
     |> assign(:uploaded_files, [])
     |> allow_upload(:manipulated_media,
       accept: ~w(.mp4 .wav),
       max_entries: 1,
       external: &presign_upload/2,
       auto_upload: true
     )}
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
    uploaded_files =
      consume_uploaded_entries(socket, :manipulated_media, fn %{key: _key}, entry ->
        save_manipulated_media(
          socket,
          socket.assigns.action,
          Map.put(manipulated_media_params, "url", "/canon/manipulated-media/" <> entry.uuid)
        )

        {:ok, entry}
      end)

    {:noreply, update(socket, :uploaded_files, &(&1 ++ uploaded_files))}
    # {:noreply, socket}
  end

  defp save_manipulated_media(socket, :edit, manipulated_media_params) do
    case Canon.update_manipulated_media(
           socket.assigns.manipulated_media,
           manipulated_media_params
         ) do
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

  defp presign_upload(entry, socket) do
    uploads = socket.assigns.uploads
    bucket = "staging.dau.tattle.co.in"
    key = "canon/manipulated-media/#{entry.uuid}"

    config = %{
      region: "ap-south-1",
      access_key_id: Application.get_env(:dau, :aws_access_key_id),
      secret_access_key: Application.get_env(:dau, :aws_secret_access_key)
    }

    {:ok, fields} =
      SimpleS3Upload.sign_form_upload(config, bucket,
        key: key,
        content_type: entry.client_type,
        max_file_size: uploads[entry.upload_config].max_file_size,
        expires_in: :timer.hours(1)
      )

    meta = %{
      uploader: "S3",
      key: key,
      url: "https://s3.#{config.region}.amazonaws.com/#{bucket}",
      # url: "https://#{bucket}.s3-#{config.region}.amazonaws.com",
      fields: fields
    }

    {:ok, meta, socket}
  end
end
