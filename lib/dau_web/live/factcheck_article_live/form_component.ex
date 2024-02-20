defmodule DAUWeb.FactcheckArticleLive.FormComponent do
  use DAUWeb, :live_component

  alias DAU.Canon

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage factcheck_article records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="factcheck_article-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:url]} type="text" label="Url" />
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:publisher]} type="text" label="Publisher" />
        <.input field={@form[:author]} type="text" label="Author" />
        <.input field={@form[:excerpt]} type="text" label="Excerpt" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Factcheck article</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{factcheck_article: factcheck_article} = assigns, socket) do
    changeset = Canon.change_factcheck_article(factcheck_article)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"factcheck_article" => factcheck_article_params}, socket) do
    changeset =
      socket.assigns.factcheck_article
      |> Canon.change_factcheck_article(factcheck_article_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"factcheck_article" => factcheck_article_params}, socket) do
    save_factcheck_article(socket, socket.assigns.action, factcheck_article_params)
  end

  defp save_factcheck_article(socket, :edit, factcheck_article_params) do
    case Canon.update_factcheck_article(socket.assigns.factcheck_article, factcheck_article_params) do
      {:ok, factcheck_article} ->
        notify_parent({:saved, factcheck_article})

        {:noreply,
         socket
         |> put_flash(:info, "Factcheck article updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_factcheck_article(socket, :new, factcheck_article_params) do
    case Canon.create_factcheck_article(factcheck_article_params) do
      {:ok, factcheck_article} ->
        notify_parent({:saved, factcheck_article})

        {:noreply,
         socket
         |> put_flash(:info, "Factcheck article created successfully")
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
