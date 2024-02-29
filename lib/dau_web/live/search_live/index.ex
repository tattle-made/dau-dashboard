defmodule DAUWeb.SearchLive.Index do
  use DAUWeb, :live_view
  use DAUWeb, :html

  def render(assigns) do
    ~H"""
    <section class="flex flex-col gap-2">
      <div class="flex flex-row gap-1 ">
        <div class="flex flex-row gap-1">
          <div class="w-2/3 border-2 border-green-50 overflow-hidden">
            <video controls>
              <source
                src="https://github.com/tattle-made/feluda/raw/main/src/core/operators/sample_data/sample-cat-video.mp4"
                type="video/mp4"
              />
            </video>
          </div>
          <div class="flex flex-col  gap-4 p-2 w-1/3 rounded-sm border-2 border-green-50">
            <p class="text-lg">Status Summary</p>
            <div class="align-center flex flex-row gap-2 items-center ">
              <div class="rounded-lg w-4 h-4 bg-green-200"></div>
              <p class="text-xs">Categorization</p>
            </div>
            <div class="align-center flex flex-row gap-2 items-center ">
              <div class="rounded-lg w-4 h-4 border-2"></div>
              <p class="text-xs">Expert Reports (1/3)</p>
            </div>
            <div class="align-center flex flex-row gap-2 items-center ">
              <div class="rounded-lg w-4 h-4 border-2"></div>
              <p class="text-xs">User Response</p>
            </div>
          </div>
        </div>
      </div>
      <div class="flex flex-row gap-1">
        <div class="p-2 border-2 border-green-50  rounded-sm w-1/2">
          <p class="text-lg">Categories</p>
          <input id="checkbox-manipulated" type="checkbox" value="" class="" />
          <label for="checkbox-manipulated" class="ms-2 text-sm font-medium">Manipulated</label>
          <div class="h-2" />
          <div class="flex flex-row flex-wrap gap-1">
            <div class="flex flex-row items-center gap-x-2 bg-green-200  p-1 rounded-md border-2 border-green-50 w-fit">
              <p class="text-stone-800 text-xs">cheapfake</p>
              <span class="hero-x-mark-solid w-3 h-3" />
            </div>
            <div class="flex flex-row items-center gap-x-2 bg-green-200  p-1 rounded-md border-2 border-green-50 w-fit">
              <p class="text-stone-800 text-xs">lipsync</p>
              <span class="hero-x-mark-solid w-3 h-3" />
            </div>
            <div class="flex flex-row items-center gap-x-2 bg-green-200  p-1 rounded-md border-2 border-green-50 w-fit">
              <p class="text-stone-800 text-xs">audio-mismatch</p>
              <span class="hero-x-mark-solid w-3 h-3" />
            </div>
          </div>
          <button
            id="dropdownContainer"
            data-dropdown-toggle="dropdownContent"
            class="bg-green-50 p-1 text-xs flex flex-row align-center"
          >
            Subcategories
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
                <label for="id-opt-1"> Deepfake </label>
              </div>

              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1"> Cheapfake </label>
              </div>
              <div class="p-1">
                <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                <label for="id-opt-1"> AI-Generated </label>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    """
  end

  def mount(params, session, socket) do
    IO.inspect(params)
    IO.inspect(session)
    IO.inspect(socket)
    query = ""
    {:ok, assign(socket, :query, query)}
  end

  # def handle_params(unsigned_params, uri, socket) do
  # end

  # def handle_event(event, unsigned_params, socket) do
  # end

  def handle_event("test-click", value, socket) do
    IO.inspect(value)
    query = socket.assigns.query <> value["value"]
    {:noreply, assign(socket, :query, query)}
  end
end
