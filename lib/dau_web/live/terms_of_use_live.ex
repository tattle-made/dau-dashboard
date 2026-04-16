defmodule DAUWeb.TermsOfUseLive do
  use DAUWeb, :live_view
  on_mount {DAUWeb.UserAuth, :mount_current_user}

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-4xl p-6">
      <h1 class="text-3xl font-bold text-gray-900 mb-8">Terms of Use</h1>

      <div class="space-y-6 text-gray-700">
        <p class="leading-relaxed">
          Please read these terms of use carefully before using the
          <strong>Deepfakes Analysis Unit(DAU)</strong>
          dataset hosted by <strong>Tattle</strong>
          and <strong>Deepfakes Analysis Unit</strong>.
        </p>

        <div class="space-y-6">
          <div>
            <h2 class="text-xl font-semibold text-gray-900 mb-3">Purpose of Dataset</h2>
            <p class="leading-relaxed">
              The <strong>DAU Data Preview</strong>
              consists of two datasets - <strong>Whatsapp Tipline Preview dataset</strong>
              and the <strong>External Escalations Preview Dataset</strong>. Both datasets are intended for
              <strong>non-commercial use only</strong>
              such as but not limited to research, archival, journalistic, and statistical analysis. The intention of releasing this dataset is to encourage research and understanding of trends in creation of deepfakes, use of AI tools to manipulate media items, and the spread of AI-generated misinformation.
            </p>
          </div>

          <div>
            <h2 class="text-xl font-semibold text-gray-900 mb-3">Conditions of Use</h2>
            <div class="space-y-4 leading-relaxed">
              <p>
                By using this website, you certify that you have read and reviewed this Agreement and that you agree to comply with its terms. If you do not want to be bound by the terms of this Agreement, you are advised to leave the website accordingly.
                <strong>Tattle</strong>
                and <strong>DAU</strong>
                only grant use and access of this website, its products, and its services to Data License those who have accepted its terms.
              </p>
              <div>
                <p class="font-medium mb-2">
                  You must include attribution for the data you use as follows:
                </p>
                <ul class="list-disc list-inside space-y-2 ml-4">
                  <li>
                    The <strong>DAU Data Preview, March 2026</strong>. URL:
                    <a
                      href="https://dau.tattle.co.in/datasets"
                      class="text-blue-600 hover:text-blue-800 underline font-medium"
                      target="_blank"
                    >
                      https://dau.tattle.co.in/datasets
                    </a>
                  </li>
                </ul>
              </div>
              <p>
                You must not claim or imply that <strong>Tattle</strong>
                or the <strong>Deepfakes Analysis Unit</strong>
                endorses your use of the data by or use either organizations logo(s) or trademark(s) in conjunction with such use.
              </p>
            </div>
          </div>

          <div>
            <h2 class="text-xl font-semibold text-gray-900 mb-3">Content Warning</h2>
            <p class="leading-relaxed">
              This dataset contains content that may be <strong>triggering for some users</strong>
              including nudity, graphic violence, hate speech, etc. It is advised that users proceed with caution when viewing, using, and presenting this dataset, especially when minors may be involved in encountering the contents of this dataset. Please provide adequate content warnings where needed to ensure the wellbeing of your interlocutors.
            </p>
          </div>

          <div>
            <h2 class="text-xl font-semibold text-gray-900 mb-3">User Accounts</h2>
            <p class="leading-relaxed">
              We reserve all rights to <strong>terminate accounts, edit or remove content</strong>
              upon misuse of the platform.
            </p>
          </div>

          <div>
            <h2 class="text-xl font-semibold text-gray-900 mb-3">Use Restrictions</h2>
            <p class="leading-relaxed">
              The data is shared for <strong>evaluation purposes only</strong>
              and cannot be used for training or for <strong>commercial purposes</strong>. You may not sell, rent, lease, or use the datasets for any commercial purpose.
            </p>
          </div>

          <div>
            <h2 class="text-xl font-semibold text-gray-900 mb-3">Limitation on Liability</h2>
            <p class="leading-relaxed">
              <strong>Tattle</strong>
              and <strong>DAU</strong>
              make no warranties with respect to the data and you agree that the organizations shall not be liable to you in connection with your use of the data.
            </p>
          </div>
        </div>
      </div>

      <div class="mt-8 text-center">
        <.link navigate={~p"/"} class="text-blue-600 hover:text-blue-800 underline font-bold">
          Back to Home
        </.link>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end
end
