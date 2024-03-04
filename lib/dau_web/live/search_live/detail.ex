defmodule DAUWeb.SearchLive.Detail do
  use DAUWeb, :live_view
  use DAUWeb, :html

  def render(assigns) do
    ~H"""
    <section class="flex flex-col gap-2">
      <div class="flex flex-row gap-1 ">
        <div class="flex flex-row gap-1">
          <div class="w-1/3 border-2 border-green-50 overflow-hidden">
            <video controls>
              <source
                src="https://github.com/tattle-made/feluda/raw/main/src/core/operators/sample_data/sample-cat-video.mp4"
                type="video/mp4"
              />
            </video>
          </div>

          <div class="flex flex-col gap-2 p-2 w-2/3 h-fit rounded-md border-2 border-green-100">
            <div class="flex flex-row gap-2">
              <p class="text-lg text-slate-900">Verdict:</p>
              <p class="text-lg text-green-500">Pending</p>
            </div>

            <div class="align-center flex flex-row gap-2 items-center ">
              <div class="rounded-lg w-4 h-4 bg-green-200"></div>
              <p class="text-xs">Tagging</p>
            </div>

            <div class="align-center flex flex-row gap-2 items-center ">
              <div class="rounded-lg w-4 h-4 border-2"></div>
              <p class="text-xs">Expert Reports (2/3)</p>
            </div>
            <div class="align-center flex flex-row gap-2 items-center ">
              <div class="rounded-lg w-4 h-4 border-2"></div>
              <p class="text-xs">User Response</p>
            </div>
          </div>
        </div>
      </div>

      <div class="flex flex-row gap-1">
        <div class="p-2 w-1/2 rounded-md border-2 border-green-100">
          <p class="text-lg">Tagging</p>

          <div class="h-4" />
          <div class="flex flex-row flex-wrap gap-1">
            <div class="flex flex-row items-center gap-x-2 bg-green-200  p-1 rounded-md border-2 border-green-50 w-fit">
              <p class="text-stone-800 text-xs">Cheapfake</p>
              <span class="hero-x-mark-solid w-3 h-3" />
            </div>
            <div class="flex flex-row items-center gap-x-2 bg-green-200  p-1 rounded-md border-2 border-green-50 w-fit">
              <p class="text-stone-800 text-xs">AI-voice</p>
              <span class="hero-x-mark-solid w-3 h-3" />
            </div>
            <div class="flex flex-row items-center gap-x-2 bg-green-200  p-1 rounded-md border-2 border-green-50 w-fit">
              <p class="text-stone-800 text-xs">Phase-2</p>
              <span class="hero-x-mark-solid w-3 h-3" />
            </div>
          </div>
          <div class="h-2" />
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
        </div>
      </div>

      <div class="flex flex-row gap-1">
        <div class="p-2 w-1/2 rounded-md border-2 border-green-100">
          <p class="text-lg">Forensic Analysis</p>
          <p class="text-xs text-green-950">Awaiting Response from IISc</p>
          <div class="flex flex-row items-center gap-x-2">
            <p class="text-stone-800 text-xs">Response submitted by getreallabs</p>
            <span class="hero-arrow-down-tray w-3 h-3 cursor-pointer" />
          </div>
          <div class="bg-red py-2">
            <button
              id="partnerDropdownContainer"
              data-dropdown-toggle="partnerDropdownContent"
              class="bg-green-50 p-1 text-xs flex flex-row align-center"
            >
              Share with
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
            <div id="partnerDropdownContent" class="hidden p-2 bg-slate-200">
              <div class="flex flex-col">
                <div class="p-1">
                  <input type="checkbox" phx-click="test-click" id="id-opt-1" value="value-opt-1" />
                  <label for="id-opt-1" class="text-xs"> IIT Jodhpur </label>
                </div>

                <div class="p-1">
                  <input type="checkbox" id="id-opt-1" value="value-opt-1" />
                  <label for="id-opt-1" class="text-xs"> DeFAKE </label>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="flex flex-row gap-1">
        <div class="p-2 w-1/2 rounded-md border-2 border-green-100">
          <p class="text-lg">Factcheck Articles</p>
          <div class=" flex flex-row items-center gap-x-2">
            <p class="text-stone-800 text-xs">kritika has linked an article</p>
            <span class="hero-link w-3 h-3 cursor-pointer" />
          </div>
          <div class="flex flex-row items-center gap-x-2">
            <p class="text-stone-800 text-xs">rakesh has linked an article</p>
            <span class="hero-link w-3 h-3 cursor-pointer" />
          </div>
          <div class="py-2">
            <textarea
              id="message"
              rows="1"
              class="block p-2.5 w-full text-xs text-gray-900 bg-gray-50 rounded-sm border border-gray-300 focus:ring-green-300 focus:border-green-300 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-green-500 dark:focus:border-green-500"
              placeholder="Add link"
            ></textarea>
          </div>
        </div>
      </div>

      <div class="flex flex-row gap-1">
        <div class="p-2 w-1/2 rounded-md border-2 border-green-100">
          <p class="text-lg">Resources</p>
          <p class="text-xs text-gray-400">Share relevant resources with the community</p>
          <textarea
            id="user-message"
            rows="1"
            class="block p-2.5 w-full text-xs text-gray-900 bg-gray-50 rounded-sm border border-gray-300 focus:ring-green-300 focus:border-green-300 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-green-500 dark:focus:border-green-500"
            placeholder="Add Resource"
          ></textarea>
        </div>
      </div>

      <div class="flex flex-row gap-1">
        <div class="p-2 w-1/2 rounded-md border-2 border-green-100">
          <p class="text-lg">Assessment Report</p>
          <textarea
            id="user-message"
            rows="1"
            class="block p-2.5 w-full text-xs text-gray-900 bg-gray-50 rounded-sm border border-gray-300 focus:ring-green-300 focus:border-green-300 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-green-500 dark:focus:border-green-500"
            placeholder="Add Report Link"
          ></textarea>
        </div>
      </div>

      <div class="flex flex-row gap-1">
        <div class="p-2 w-1/2 rounded-md border-2 border-green-100">
          <p class="text-lg">User Response</p>
          <textarea
            id="user-message"
            rows="14"
            class="block p-2.5 w-full text-xs text-gray-900 bg-gray-50 rounded-sm border border-gray-300 focus:ring-green-300 focus:border-green-300 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-green-500 dark:focus:border-green-500"
            placeholder="We reviewed this audio note and found it to be a AI generated.
            You can read our assessment report here: https://link-to-report.html
            Fact checkers have also shared the following:
            1. Newschecker: Video of Lion flying is not real
            https://link-to-boom-report.html
            2. THIP : Lions cant fly. Video is AI generated
            https://link-to-factly-report.html
            Please use your thoughtful discretion in sharing this forward.
            Thank you reaching out to use. We hope you have a good day ahead."
          ></textarea>
          <div>
            <button class="border-2 border-green-100 bg-green-50 m-2 rounded-md" disabled>
              <p class="text-xs p-2">Send to User</p>
            </button>
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
