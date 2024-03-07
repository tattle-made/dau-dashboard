defmodule DAUWeb.SearchLive.Verification do
  alias DauWeb.SearchLive.Data
  use DAUWeb, :live_view
  use DAUWeb, :html

  def render(assigns) do
    ~H"""
    <.back navigate={~p"/demo/query"}>Back to feed</.back>
    <div class="mb-4" />
    <div class="flex flex-row gap-8 items-center mb-4">
      <h1 class="text-xl font-normal text-slate-900 ">
        Verification Notes
      </h1>
    </div>
    <div class="flex flex-col sm:flex-row gap-4">
      <div class="w-1/2 border-2 rounded-md border-green-100 p-4">
        <.query type={@query.type} url={@query.url} />
      </div>
      <div class="w-1/2 h-fit border-2 rounded-md border-green-100 p-4 flex flex-col gap-2">
        <dau-rich-text-editor />

        <button
          id="dropdownContainer"
          data-dropdown-toggle="dropdownContent"
          class="bg-green-50 p-1 text-xs flex flex-row align-center w-fit"
        >
          Add tags
          <svg
            class="w-3 h-3 ml-2"
            aria-hidden="true"
            fill="none"
            stroke="currentColor"
            viewBox="0 0 24 24"
            xmlns="http://www.w3.org/2000/svg"
          >
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7">
            </path>
          </svg>
        </button>
        <div id="dropdownContent" class="hidden p-2 bg-slate-200">
          <div class="flex flex-col">
            <div class="p-1">
              <input type="checkbox" phx-click="test-click" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Suspected Cheapfake </label>
            </div>

            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Suspected Deepfake </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Deepfake </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Cheapfake </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> AI-voice </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> AI-video </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Manipulated video </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Manipulated audio </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> faceswap </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> AI-image </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> political fakes </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Phase-1 </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Phase-2 </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Real Video, AI Voice </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Real Video, Real Voice </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> AI Video, Real Voice </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Real Video, Real Voice </label>
            </div>
            <div class="p-1">
              <input type="checkbox" id="id-opt-1" value="value-opt-1" />
              <label for="id-opt-1" class="text-xs"> Out of scope </label>
            </div>
          </div>
        </div>
        <div class="bg-red-200 p-2">
          <p>WIP : Add more workflow items here</p>
        </div>
      </div>
    </div>
    """
  end

  def mount(params, session, socket) do
    {:ok, socket}
  end

  def handle_params(params, uri, socket) do
    IO.puts("params go here")
    IO.inspect(params)
    query = Data.queries() |> Enum.filter(fn query -> query.id == params["id"] end) |> hd
    {:noreply, assign(socket, :query, query)}
  end
end
