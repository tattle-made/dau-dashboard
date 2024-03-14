defmodule DAUWeb.SearchLive.Verification do
  alias DAU.Feed
  alias DauWeb.SearchLive.Data
  alias DAU.Feed.Common
  use DAUWeb, :live_view
  use DAUWeb, :html

  def mount(_params, _session, socket) do
    form =
      %Common{}
      |> Common.annotation_changeset(%{tags: [], verification_note: ""})
      |> to_form()

    socket =
      socket
      |> assign(:form, form)
      |> assign(:query, %{})

    {:ok, socket}
  end

  def handle_params(params, uri, socket) do
    query_id = String.to_integer(params["id"])
    query = Feed.get_feed_item_by_id(query_id)
    query_changeset = query |> Common.annotation_changeset()

    socket =
      socket
      |> assign(:query, query)
      |> assign(:form, to_form(query_changeset))

    {:noreply, socket}
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
    IO.inspect(params)
    query = socket.assigns.query
    verification_note = params["common"]["verification_note"]
    tags = socket.assigns.tags

    attributes = %{"verification_note" => verification_note, "tags" => tags}

    case Feed.add_secratariat_notes(query, attributes) do
      {:ok, _user} ->
        {
          :noreply,
          socket
          |> put_flash(:info, "verification notes updated")
          |> redirect(to: ~p"/demo/query/pg/1")
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

    socket =
      socket
      |> assign(:tags, new_tags)
      |> assign(:form, to_form(changeset))

    {:noreply, socket}
  end

  def handle_event("add-tag", value, socket) do
    changeset = socket.assigns.form.source
    tags = Ecto.Changeset.get_field(changeset, :tags) || []
    new_tags = [value["tag"] | tags]

    changeset =
      socket.assigns.form.source
      |> Ecto.Changeset.put_change(:tags, new_tags)

    socket =
      socket
      |> assign(:tags, new_tags)
      |> assign(:form, to_form(changeset))

    {:noreply, socket}
  end
end
