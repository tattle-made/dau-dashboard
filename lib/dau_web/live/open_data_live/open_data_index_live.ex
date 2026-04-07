defmodule DAUWeb.OpenDataLive.OpenDataIndexLive do
  use DAUWeb, :live_view
  use DAUWeb, :html

  @impl Phoenix.LiveView
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <div class="mx-auto w-full max-w-5xl px-4 py-10">
      <div class="flex flex-col gap-2">
        <h1 class="text-2xl font-semibold text-slate-900">DAU Open Datasets</h1>
        <p class="text-sm text-slate-600">
          Two curated datasets from the Deepfakes Analysis Unit (DAU), with documentation and
          sample records. Use the cards below to explore each source.
        </p>
      </div>

      <div
        id="colocated-hook-demo"
        phx-hook=".HelloHook"
        class="mt-6 rounded-md border border-dashed border-zinc-300 bg-slate-50 p-4 text-sm text-slate-700 transition-colors"
      >
        <div class="flex items-center justify-between gap-4">
          <div>
            <p class="text-xs font-semibold uppercase tracking-wide text-slate-500">
              Colocated Hook Demo
            </p>
            <p class="mt-1">
              Count: <span data-count>0</span>
            </p>
            <p class="text-xs text-slate-500" data-status>
              Waiting for mount...
            </p>
          </div>
          <button
            type="button"
            data-action
            class="inline-flex items-center rounded-md bg-slate-900 px-3 py-2 text-xs font-semibold text-white shadow-sm hover:bg-slate-800"
          >
            Click me
          </button>
        </div>
      </div>

      <script :type={Phoenix.LiveView.ColocatedHook} name=".HelloHook">
        export default {
          mounted() {
            this.count = 0;
            this.countEl = this.el.querySelector("[data-count]");
            this.statusEl = this.el.querySelector("[data-status]");
            this.buttonEl = this.el.querySelector("[data-action]");

            this.buttonEl.addEventListener("click", () => this.increment());
            this.statusEl.textContent = "Mounted. Click the button to test.";
            this.update();
          },
          increment() {
            this.count += 1;
            this.update();
          },
          update() {
            this.countEl.textContent = this.count;

            if (this.count % 2 === 0) {
              this.el.classList.remove("bg-emerald-50");
              this.el.classList.add("bg-slate-50");
            } else {
              this.el.classList.remove("bg-slate-50");
              this.el.classList.add("bg-emerald-50");
            }
          }
        }
      </script>


      <div class="mt-8 flex flex-col gap-6">
        <div class="flex h-full flex-col rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
          <div class="flex items-start justify-between gap-4">
            <div>
              <p class="text-xs font-medium uppercase tracking-wide text-slate-500">
                Dataset 1
              </p>
              <h2 class="mt-1 text-lg font-semibold text-slate-900">
                Deepfakes Analysis Unit Dataset 1: Sourced from Whatsapp Tipline
              </h2>
            </div>
          </div>

          <div class="mt-4 space-y-3 text-sm text-slate-700">
            <p>
              This dataset consists of media items including images, audio files, and video files sent to the Deepfakes Analysis Unit (DAU) for inspection due to the sender suspecting that the item has been altered or synthesized using AI tools. The DAU has analysed each data item using AI detection tools and fact checking research to determine the presence or absence of AI manipulation.
            </p>
            <p>
              The data was reported to DAU via a Whatsapp tipline, between March 21, 2024 and February 16, 2026.
            </p>
            <p>
              The dataset was reviewed by one of three fact checkers at DAU and each entry described with various fields of metadata. The data dictionary for this dataset is available on its table page.
            </p>
            <p>
              Some things to note about the data:
            </p>
            <p>
              1. Assessment reports have only been generated and attached for media items considered of public importance due to the nature of the content or virality of the media item. Therefore, there is a limited subset of items in both datasets with assessment reports.
            </p>
            <p>
              2. The DAU did not archive media items that were shared with them as URLs, as a result, some links in the data are broken. This represents the way synthetic content circulates and disappears from the internet and we have chosen to maintain these links in the dataset for transparency.
            </p>
            <p>
              The licensing for this dataset is shared below.
            </p>
          </div>

          <div class="mt-6">
            <.link
              navigate="/datasets/preview/whatsapp-tipline-dataset"
              class="inline-flex items-center gap-2 rounded-md bg-slate-900 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-slate-800"
            >
              View Dataset 1 <span aria-hidden="true">→</span>
            </.link>
          </div>
        </div>

        <div class="flex h-full flex-col rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
          <div class="flex items-start justify-between gap-4">
            <div>
              <p class="text-xs font-medium uppercase tracking-wide text-slate-500">
                Dataset 2
              </p>
              <h2 class="mt-1 text-lg font-semibold text-slate-900">
                Deepfakes Analysis Unit Dataset 2: Sourced from partner escalations and social media monitoring.
              </h2>
            </div>
          </div>

          <div class="mt-4 space-y-3 text-sm text-slate-700">
            <p>
              This dataset consists of media items including images, audio files, and video files suspected to have been altered using AI, which were either sent to the Deepfakes Analysis Unit (DAU) for inspection by a partner or found online through social media monitoring. The DAU has analysed each data item using AI detection tools and conducting fact checking research to determine the presence or absence of AI manipulation. The primary geographical focus of the dataset is India. The dataset has been divided into two sections based on the channel of receiving the data. This documentation pertains to the dataset sourced from partner escalations or social media monitoring. The data was collected between March 21, 2024 and February 16, 2026.
            </p>
            <p>
              Each media item was reviewed by one of three fact checkers at DAU and each entry described with various fields of metadata. The data dictionary for this dataset is available on its table page.
            </p>
            <p>
              Some things to note:
            </p>
            <p>
              1. Assessment reports have only been generated and attached for media items considered of public importance due to the nature of the content or virality of the media item. Therefore, there is a limited subset of items with assessment reports.
            </p>
            <p>
              2. There are some redundancies in the dataset from 'Other sources' as media items with assessement reports were recorded twice. Therefore, you might come across two entries for the same media item with similar metadata but one with an assessment report and one without. Additionally, the item's URL links might also be different as media items were taken down after our initial analysis but the item may have reappeared elsewhere on the internet later.
            </p>
            <p>
              3. There are differences in the metadata fields available for the two datasets and we have retained these differences to maintain transparency about the process of verifying and recording manipulation in each item.
            </p>
            <p>
              4. The DAU did not archive media items that were shared with them as URLs, as a result, some links in the data are broken. This represents the way synthetic content circulates and disappears from the internet and we have chosen to maintain these links in the dataset.
            </p>
            <p>
              The licensing for this dataset is shared below.
            </p>
          </div>

          <div class="mt-6">
            <.link
              navigate="/datasets/preview/escalations"
              class="inline-flex items-center gap-2 rounded-md bg-slate-900 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-slate-800"
            >
              View Dataset 2 <span aria-hidden="true">→</span>
            </.link>
          </div>
        </div>
      </div>

      <div class="mt-10 rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
        <div class="flex flex-col gap-3">
          <div>
            <p class="text-xs font-medium uppercase tracking-wide text-slate-500">Licensing</p>
            <h2 class="mt-1 text-lg font-semibold text-slate-900">Dataset Licensing</h2>
          </div>
          <p class="text-sm text-slate-700">
            The data presented here is a limited sample of the entire dataset. In that we share only screenshots from the media item or its URL. Complete media items are not available. For access to the full dataset please submit a request to DAU directly. For ethical commercial use cases, the dataset can be made available at a charge.
          </p>
          <div>
            <.link
              navigate="https://docs.google.com/document/u/0/d/1iY_E2cKKm8EXSFAqQrvEl1wD4OLkNitS20RuDnGBMIY"
              target="_blank"
              rel="noopener noreferrer"
              class="inline-flex items-center gap-2 rounded-md bg-slate-900 px-4 py-2 text-sm font-semibold text-white shadow-sm hover:bg-slate-800"
            >
              View DAU Data License <span aria-hidden="true">→</span>
            </.link>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
