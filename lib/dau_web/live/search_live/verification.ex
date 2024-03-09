defmodule DAUWeb.SearchLive.Verification do
  alias DAU.Feed
  alias DauWeb.SearchLive.Data
  alias DAU.Feed.Common
  use DAUWeb, :live_view
  use DAUWeb, :html

  def mount(_params, _session, socket) do
    form =
      Feed.get_feed_item_by_id(1)
      |> Common.annotation_changeset()
      |> to_form()

    {:ok, assign(socket, :form, form)}
  end

  def handle_params(params, uri, socket) do
    IO.puts("params go here")
    IO.inspect(params)
    query = Data.queries() |> Enum.filter(fn query -> query.id == params["id"] end) |> hd
    {:noreply, assign(socket, :query, query)}
  end

  def handle_event("validate", %{"common" => common}, socket) do
    changeset_form =
      socket.assigns.form.source
      |> Common.annotation_changeset(common)
      |> Map.put(:action, :insert)
      |> to_form()

    {:noreply, assign(socket, :form, changeset_form)}
  end

  def handle_event("save", params, socket) do
    case(
      socket.assigns.form.source
      |> Feed.add_secratariat_notes()
    ) do
      {:ok, _user} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "verification notes updated")
          # |> redirect(to: ~p"/users/#{user}")
        }

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def handle_event("remove-tag", value, socket) do
    changeset = socket.assigns.form.source
    tags = Ecto.Changeset.get_field(changeset, :tags)
    new_tags = List.delete(tags, value["tag"])

    changeset =
      socket.assigns.form.source
      |> Ecto.Changeset.put_change(:tags, new_tags)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("add-tag", value, socket) do
    changeset = socket.assigns.form.source
    tags = Ecto.Changeset.get_field(changeset, :tags)
    new_tags = [value["tag"] | tags]

    changeset =
      socket.assigns.form.source
      |> Ecto.Changeset.put_change(:tags, new_tags)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end
end
