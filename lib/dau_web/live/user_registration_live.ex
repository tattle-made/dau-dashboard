defmodule DAUWeb.UserRegistrationLive do
  use DAUWeb, :live_view

  alias DAU.Accounts
  alias DAU.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="mx-auto max-w-sm">
      <.header class="text-center">
        Register for an account
        <:subtitle>
          Already registered?
          <.link navigate={~p"/users/log_in"} class="font-semibold text-brand hover:underline">
            Sign in
          </.link>
          to your account now.
        </:subtitle>
      </.header>

      <%!-- action={~p"/users/log_in?_action=registered"}
        method="post"  --> Arguments used when after registering, login is allowed without confirmation--%>

      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:email]} type="email" label="Email" required />
        <.input field={@form[:password]} type="password" label="Password" required />

        <div class="mt-6 border border-gray-300 rounded-lg p-4 bg-gray-50">
          <div class="space-y-4">
            <div>
              <h3 class="font-bold text-gray-900 mb-2 text-lg">Terms of Use</h3>
              <p class="text-sm text-gray-700">
                Please read these terms of use carefully before using the
                <strong>Deepfakes Analysis Unit(DAU)</strong>
                dataset hosted by <strong>Tattle</strong>
                and <strong>Deepfakes Analysis Unit</strong>.
              </p>
            </div>

            <div class="space-y-3">
              <div>
                <h4 class="font-semibold text-gray-900">Purpose of Dataset</h4>
                <p class="text-sm text-gray-700 mt-1">
                  The <strong>DAU Data Preview</strong>
                  consists of two datasets - <strong>Whatsapp Tipline Preview dataset</strong>
                  and the <strong>External Escalations Preview Dataset</strong>. Both datasets are intended for
                  <strong>non-commercial use only</strong>
                  such as but not limited to research, archival, journalistic, and statistical analysis. The intention of releasing this dataset is to encourage research and understanding of trends in creation of deepfakes, use of AI tools to manipulate media items, and the spread of AI-generated misinformation.
                </p>
              </div>

              <div>
                <h4 class="font-semibold text-gray-900">Conditions of Use</h4>
                <div class="text-sm text-gray-700 mt-1 space-y-2">
                  <p>
                    By using this website, you certify that you have read and reviewed this Agreement and that you agree to comply with its terms. If you do not want to be bound by the terms of this Agreement, you are advised to leave the website accordingly.
                    <strong>Tattle</strong>
                    and <strong>DAU</strong>
                    only grant use and access of this website, its products, and its services to Data License those who have accepted its terms.
                  </p>
                  <p>
                    You must include attribution for the data you use as follows: <br />

                    <li class="list-disc list-inside space-y-1 ml-2">
                      The <strong>DAU Data Preview, March 2026</strong>. URL:
                      <a
                        href="https://dau.tattle.co.in/datasets"
                        class="text-blue-600 hover:text-blue-800 underline font-medium"
                        target="_blank"
                      >
                        https://dau.tattle.co.in/datasets
                      </a>
                    </li>
                  </p>
                  <p>
                    You must not claim or imply that <strong>Tattle</strong>
                    or the <strong>Deepfakes Analysis Unit</strong>
                    endorses your use of the data by or use either organizations logo(s) or trademark(s) in conjunction with such use.
                  </p>
                </div>
              </div>

              <div>
                <h4 class="font-semibold text-gray-900">Content Warning</h4>
                <p class="text-sm text-gray-700 mt-1">
                  This dataset contains content that may be <strong>triggering for some users</strong>
                  including nudity, graphic violence, hate speech, etc. It is advised that users proceed with caution when viewing, using, and presenting this dataset, especially when minors may be involved in encountering the contents of this dataset. Please provide adequate content warnings where needed to ensure the wellbeing of your interlocutors.
                </p>
              </div>

              <div>
                <h4 class="font-semibold text-gray-900">User Accounts</h4>
                <p class="text-sm text-gray-700 mt-1">
                  We reserve all rights to <strong>terminate accounts, edit or remove content</strong>
                  upon misuse of the platform.
                </p>
              </div>

              <div>
                <h4 class="font-semibold text-gray-900">Use Restrictions</h4>
                <p class="text-sm text-gray-700 mt-1">
                  The data is shared for <strong>evaluation purposes only</strong>
                  and cannot be used for training or for <strong>commercial purposes</strong>. You may not sell, rent, lease, or use the datasets for any commercial purpose.
                </p>
              </div>

              <div>
                <h4 class="font-semibold text-gray-900">Limitation on Liability</h4>
                <p class="text-sm text-gray-700 mt-1">
                  <strong>Tattle</strong>
                  and <strong>DAU</strong>
                  make no warranties with respect to the data and you agree that the organizations shall not be liable to you in connection with your use of the data.
                </p>
              </div>
            </div>
          </div>
        </div>

        <div class="mt-4">
          <label class="flex items-start space-x-2">
            <input
              type="checkbox"
              id="terms_accepted"
              name="user[terms_accepted]"
              value="true"
              checked={@terms_accepted}
              phx-click="toggle_terms"
              class="mt-1 rounded border-gray-300 text-brand focus:ring-brand"
              required
            />
            <span class="text-sm text-gray-700">
              I have read and agree to the Terms of Use
            </span>
          </label>
          <.error :if={@terms_error}>
            {@terms_error}
          </.error>
        </div>

        <:actions>
          <.button phx-disable-with="Creating account..." class="w-full">Create an account</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(
        trigger_submit: false,
        check_errors: false,
        terms_accepted: false,
        terms_error: nil
      )
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    if socket.assigns.terms_accepted do
      case Accounts.register_user(user_params) do
        {:ok, user} ->
          {:ok, _} =
            Accounts.deliver_user_confirmation_instructions(
              user,
              &url(~p"/users/confirm/#{&1}")
            )

          {:noreply, socket |> redirect(to: ~p"/users/confirm/landing")}

        {:error, %Ecto.Changeset{} = changeset} ->
          {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
      end
    else
      {:noreply, socket |> assign(terms_error: "You must accept the terms of use to register")}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  def handle_event("toggle_terms", _params, socket) do
    new_state = !socket.assigns.terms_accepted
    error_message = if new_state, do: nil, else: "You must accept the terms of use to register"

    socket =
      socket
      |> assign(terms_accepted: new_state)
      |> assign(terms_error: error_message)

    {:noreply, socket}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
