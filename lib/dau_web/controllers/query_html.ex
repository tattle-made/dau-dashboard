defmodule DAUWeb.QueryHTML do
  use DAUWeb, :html

  def index(assigns) do
    ~H"""
    <h1>Queries</h1>
    <%= if @comment.data.type==:plain_text do %>
      <textarea rows="4" cols="50">
      </textarea>
    <% end %>

    <%= if @comment.data.type==:checklist do %>
      <input type="checkbox" id="vehicle1" name="vehicle1" value="Bike" />
      <label for="vehicle1"> I have found a source</label> <br />
      <input type="checkbox" id="vehicle1" name="vehicle1" value="Bike" />
      <label for="vehicle1"> I have found a primary witness</label> <br />
      <input type="checkbox" id="vehicle1" name="vehicle1" value="Bike" />
      <label for="vehicle1"> I have found this image online</label> <br />
    <% end %>

    <%= for query <- @queries do %>
      <div class="rounded-lg py-2 my-2 border-2 border-slate-100 ">
        <.queryt query={query} />
      </div>
    <% end %>
    """
  end
end
