defmodule DAUWeb.AssessmentReportMetadataHTML do
  use DAUWeb, :html

  def show(assigns) do
    theme_radio_labels = [
      "Civic Issues (matters of infrastructure, eg., potholes, accidents, breakdown of infrastructure)",
      "Government Schemes (related to policies or schemes e.g., generative text misrepresenting policy priorities)",
      "Political (includes matters dealing with politicians or political parties e.g., campaigns, leader speeches, party worker deeds etc.)",
      "Communal (in cases where negative sentiments are associated with religion/ethnic identity)",
      "Defense (matters tied to the Indian defense forces e.g., scripted imagery of military exercises)",
      "Crime (Robbery/ murder/ cyber crime/ bribery/raids)",
      "Economy (Includes budget, taxes, GST, road cess, Petrol & LPG prices)",
      "Scams (Job scams/ financial scams & phishing attempts/ Promises of car et al)",
      "Health (health hoaxes, quack advice e.g., Dr Naresh Trehan Deepfake)",
      "IT & Science (tech related matters e.g., cybertruck accidents)",
      "Entertainment (deals with celeb conduct, movie related matters)",
      "Sports (deals with sporting events, sportsman conduct)",
      "Tragedy (Freak incidents, natural disasters, loss of lives e.g.,)",
      "Foreign Affairs (matters pertaining to other countries including, internal politics/policies/economy)",
      "Judiciary (Court orders/ news about some judge/ pending cases)",
      "Religion (opposed to 'communal', this one is to be used in cases of positive sentiment accompanying claims)",
      "Culture (similar to above, but more generalised like cuisine, dance form etc.)",
      "International Boundary Dispute (e.g., secession, incursions, skirmishes around border, eg., Indo-China, Indo-Pakistan)",
      "Business (Generative content targeting companies and/or their figureheads)",
      "Influencer/Public Figure"
    ]

    checkbox_labels = ["Male", "Female", "Male (Trans Male)", "Female (Trans Female)", "LGBQIA+"]
    yes_no_labels = ["Yes", "No"]
    claim_categories = ["Graphic", "Pornographic/Sexual", "Violent", "Expletives"]
    pos_neg_labels = ["Positive", "Negative", "Neutral", "Inconclusive"]

    ~H"""
    <div>
      <.simple_form for={@form} action={"/demo/query/#{@id}/assessment-report/metadata"}>
        <.input field={@form[:link]} label="Link Of Assessment Report *" required />
        <.input field={@form[:target]} label="Who is the post/claim targeting?" />
        <.input
          field={@form[:language]}
          type="select"
          label="The language used in the audio/video"
          prompt="Choose Language"
          options={[
            {"English", "en"},
            {"Hindi", "hi"},
            {"Tamil", "ta"},
            {"Telugu", "te"}
          ]}
        />
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Primary Theme of claim (Explicit subject of the claim) <span class="text-red-700">*</span>
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(theme_radio_labels) do %>
              <.radio_group field={@form[:primary_theme]} required={true}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Secondary theme of that claim
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(theme_radio_labels) do %>
              <.radio_group field={@form[:secondary_theme]} required={false}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <.input
          field={@form[:third_theme]}
          label="Follow-up to previous question, is there a third claim category that you'd like to mention?"
        />
        <.input
          field={@form[:claim_is_sectarian]}
          label="If the claim is sectarian in nature, identify the community targeted by the claim?"
        />
        <%!-- <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Is the claim targeting a gender? If so, please specify the group targeted.
          </label>
          <div class="mt-2">
            <.input field={@form[:gender]} type="checkbox" label="hi" value="helllooo" />
            <.input field={@form[:gender2]} type="checkbox" label="hello" value="helllooo" />
          </div>
        </div> --%>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Is the content of the question disturbing or triggering?
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(yes_no_labels) do %>
              <.radio_group field={@form[:content_disturbing]} required={false}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            If yes to the previous question, did the claim fall under any of the following categories?
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(claim_categories) do %>
              <.radio_group field={@form[:claim_category]} required={false}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Did the claim carry a logo similar to that of recognised organisation (Imposter content)
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(yes_no_labels) do %>
              <.radio_group field={@form[:claim_logo]} required={false}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <.input field={@form[:org_logo]} label="If yes, which organisation's logo did it imitate?" />
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Was this A.I.-generated misinformation used to frame the image of an individual/organisation in a negative or positive light?
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(pos_neg_labels) do %>
              <.radio_group field={@form[:frame_org]} required={true}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <.input
          field={@form[:medium_of_content]}
          type="select"
          label="Medium of content (Note - we should be able to capture the source eventually if possible)"
          prompt="Choose"
          options={[
            {"Video", "video"},
            {"Audio", "audio"},
            {"Link", "link"}
          ]}
          required
        />
        <:actions>
          <.button class="p-2 border-black">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def edit(assigns) do
    theme_radio_labels = [
      "Civic Issues (matters of infrastructure, eg., potholes, accidents, breakdown of infrastructure)",
      "Government Schemes (related to policies or schemes e.g., generative text misrepresenting policy priorities)",
      "Political (includes matters dealing with politicians or political parties e.g., campaigns, leader speeches, party worker deeds etc.)",
      "Communal (in cases where negative sentiments are associated with religion/ethnic identity)",
      "Defense (matters tied to the Indian defense forces e.g., scripted imagery of military exercises)",
      "Crime (Robbery/ murder/ cyber crime/ bribery/raids)",
      "Economy (Includes budget, taxes, GST, road cess, Petrol & LPG prices)",
      "Scams (Job scams/ financial scams & phishing attempts/ Promises of car et al)",
      "Health (health hoaxes, quack advice e.g., Dr Naresh Trehan Deepfake)",
      "IT & Science (tech related matters e.g., cybertruck accidents)",
      "Entertainment (deals with celeb conduct, movie related matters)",
      "Sports (deals with sporting events, sportsman conduct)",
      "Tragedy (Freak incidents, natural disasters, loss of lives e.g.,)",
      "Foreign Affairs (matters pertaining to other countries including, internal politics/policies/economy)",
      "Judiciary (Court orders/ news about some judge/ pending cases)",
      "Religion (opposed to 'communal', this one is to be used in cases of positive sentiment accompanying claims)",
      "Culture (similar to above, but more generalised like cuisine, dance form etc.)",
      "International Boundary Dispute (e.g., secession, incursions, skirmishes around border, eg., Indo-China, Indo-Pakistan)",
      "Business (Generative content targeting companies and/or their figureheads)",
      "Influencer/Public Figure"
    ]

    checkbox_labels = ["Male", "Female", "Male (Trans Male)", "Female (Trans Female)", "LGBQIA+"]
    yes_no_labels = ["Yes", "No"]
    claim_categories = ["Graphic", "Pornographic/Sexual", "Violent", "Expletives"]
    pos_neg_labels = ["Positive", "Negative", "Neutral", "Inconclusive"]

    ~H"""
    <div>
      <.simple_form for={@form} action={"/demo/query/#{@id}/assessment-report/metadata/edit"}>
        <.input field={@form[:link]} label="Link Of Assessment Report" />
        <.input field={@form[:target]} label="Who is the post/claim targeting?" />
        <.input
          field={@form[:language]}
          type="select"
          label="The language used in the audio/video"
          prompt="Choose Language"
          options={[
            {"English", "en"},
            {"Hindi", "hi"},
            {"Tamil", "ta"},
            {"Telugu", "te"}
          ]}
        />
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Primary Theme of claim (Explicit subject of the claim)
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(theme_radio_labels) do %>
              <.radio_group field={@form[:primary_theme]}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Secondary theme of that claim
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(theme_radio_labels) do %>
              <.radio_group field={@form[:secondary_theme]}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <.input
          field={@form[:third_theme]}
          label="Follow-up to previous question, is there a third claim category that you'd like to mention?"
        />
        <.input
          field={@form[:claim_is_sectarian]}
          label="If the claim is sectarian in nature, identify the community targeted by the claim?"
        />
        <%!-- <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Is the claim targeting a gender? If so, please specify the group targeted.
          </label>
          <div class="mt-2">
            <.input field={@form[:gender]} type="checkbox" label="hi" value="helllooo" />
            <.input field={@form[:gender2]} type="checkbox" label="hello" value="helllooo" />
          </div>
        </div> --%>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Is the content of the question disturbing or triggering?
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(yes_no_labels) do %>
              <.radio_group field={@form[:content_disturbing]}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            If yes to the previous question, did the claim fall under any of the following categories?
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(claim_categories) do %>
              <.radio_group field={@form[:claim_category]}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Did the claim carry a logo similar to that of recognised organisation (Imposter content)
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(yes_no_labels) do %>
              <.radio_group field={@form[:claim_logo]}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <.input field={@form[:org_logo]} label="If yes, which organisation's logo did it imitate?" />
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Was this A.I.-generated misinformation used to frame the image of an individual/organisation in a negative or positive light?
          </label>
          <div class="mt-2">
            <%= for {label, value} <- Enum.with_index(pos_neg_labels) do %>
              <.radio_group field={@form[:frame_org]}>
                <:radio value={value}><%= label %></:radio>
              </.radio_group>
            <% end %>
          </div>
        </div>
        <.input
          field={@form[:medium_of_content]}
          type="select"
          label="Medium of content (Note - we should be able to capture the source eventually if possible)"
          prompt="Choose"
          options={[
            {"Video", "video"},
            {"Audio", "audio"},
            {"Link", "link"}
          ]}
        />
        <:actions>
          <.button class="p-2 border-black">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
