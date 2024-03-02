defmodule DAUWeb.SearchLive.Index do
  use DAUWeb, :live_view
  use DAUWeb, :html

  @spec render(any()) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~H"""
    <h1 class="text-xl font-normal  text-slate-900">
      Showing all queries
    </h1>
    <div class="h-8" />

    <div class="flex flex-row">
      <div class="w-1/3">
        <.checkbox label="Unread" checked={true} />
        <div>
          <p class="py-2">Media Type</p>

          <div class="px-2">
            <.checkbox label="Video" checked={true} />
            <.checkbox label="Audio" checked={false} />
          </div>
        </div>

        <div>
          <p class="py-2">Sort</p>
          <div class="px-2">
            <.checkbox label="Newest First" checked={true} />
            <.checkbox label="Oldest First" checked={false} />
            <.checkbox label="Virality" checked={false} />
          </div>
        </div>
      </div>
      <div class="flex flex-col w-2/3 gap-2">
        <div class="w-full border-2 p-2 border-green-200 overflow-hidden rounded-md">
          <video controls>
            <source
              src="https://github.com/tattle-made/feluda/raw/main/src/core/operators/sample_data/sample-cat-video.mp4"
              type="video/mp4"
            />
          </video>
          <div class="flex flex-row gap-4">
            <div>
              <button
                id="dropdownContainer"
                data-dropdown-toggle="dropdownContent"
                class="bg-green-50 p-1 text-xs flex flex-row align-center"
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
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 9l-7 7-7-7"
                  >
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
            </div>
            <.link
              navigate={~p"/demo/query/abcd-sdfafd-asdf-asdf"}
              class="text-sm font-semibold leading-6 text-zinc-900 hover:text-zinc-700"
            >
              <p class="text-xs font-normal p-1 bg-green-200 rounded-md">View More</p>
            </.link>
          </div>
        </div>

        <div class="w-full border-2 p-2 border-green-200 overflow-hidden rounded-md">
          <audio controls>
            <source
              src="https://github.com/tattle-made/feluda/raw/main/src/core/operators/sample_data/audio.wav"
              type="video/mp4"
            />
          </audio>
        </div>

        <div class="w-full border-2 p-2 border-green-200 overflow-hidden rounded-md">
          <video controls>
            <source
              src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
              type="video/mp4"
            />
          </video>
        </div>

        <div class="w-full border-2 p-2 border-green-200 overflow-hidden rounded-md">
          <video controls>
            <source
              src="https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4"
              type="video/mp4"
            />
          </video>
        </div>
      </div>
    </div>

    <div class="flex gap-2">
      <div class="flex flex-col gap-2 "></div>
    </div>
    """
  end
end
