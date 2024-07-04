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

    yes_no_labels = ["Yes", "No"]
    claim_categories = ["Graphic", "Pornographic/Sexual", "Violent", "Expletives"]
    pos_neg_labels = ["Positive", "Negative", "Neutral", "Inconclusive"]

    ~H"""
    <div class="flex justify-center">
      <div class="w-full max-w-2xl mx-4 sm:mx-0">
        <.simple_form for={@form} action={"/demo/query/#{@id}/assessment-report/metadata"}>
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
              <span class="text-red-700">*</span>
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
          <.input
            field={@form[:gender]}
            type="checkgroup"
            label="Is the claim targeting a gender? If so, please specify the group targeted."
            multiple={true}
            options={[
              {"Male", "male"},
              {"Female", "female"},
              {"Male (Trans Male)", "trans_male"},
              {"Female (Trans Female)", "trans_female"},
              {"LGBQIA+", "lgbqia"}
            ]}
          />
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
              <span class="text-red-700">*</span>
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
            label="Medium of content (Note - we should be able to capture the source eventually if possible) *"
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

    yes_no_labels = ["Yes", "No"]
    claim_categories = ["Graphic", "Pornographic/Sexual", "Violent", "Expletives"]
    pos_neg_labels = ["Positive", "Negative", "Neutral", "Inconclusive"]

    ~H"""
    <div class="flex justify-center">
      <div class="w-full max-w-2xl mx-4 sm:mx-0">
        <.simple_form for={@form} action={"/demo/query/#{@id}/assessment-report/metadata/edit"}>
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
              <span class="text-red-700">*</span>
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
          <.input
            field={@form[:gender]}
            type="checkgroup"
            label="Is the claim targeting a gender? If so, please specify the group targeted."
            multiple={true}
            options={[
              {"Male", "male"},
              {"Female", "female"},
              {"Male (Trans Male)", "trans_male"},
              {"Female (Trans Female)", "trans_female"},
              {"LGBQIA+", "lgbqia"}
            ]}
          />
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
              <span class="text-red-700">*</span>
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
            label="Medium of content (Note - we should be able to capture the source eventually if possible) *"
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
    </div>
    """
  end

  def fetch(assigns) do
    ~H"""
    <div class="flex justify-center">
      <h1 class="text-xl font-bold">Assessment Report Metadata</h1>
    </div>
    <div>
      <.table id="table-metadata" rows={@metadata}>
        <:col :let={data} label="Feed Query ID"><%= data.feed_common_id %></:col>
        <:col :let={data} label="Link Of Assessment Report">
          <%= if data.assessment_report_url != "" do %>
            <a href={data.assessment_report_url} target="_blank" class="underline">
              <%= data.assessment_report_url %>
            </a>
          <% end %>
        </:col>
        <:col :let={data} label="Who is the post/claim targeting?"><%= data.target %></:col>
        <:col :let={data} label="The language used in the audio/video"><%= data.language %></:col>
        <:col :let={data} label="Primary Theme of claim (Explicit subject of the claim)">
          <%= data.primary_theme %>
        </:col>
        <:col :let={data} label="Secondary theme of that claim"><%= data.secondary_theme %></:col>
        <:col
          :let={data}
          label="Follow-up to previous question, is there a third claim category that you'd like to mention?"
        >
          <%= data.third_theme %>
        </:col>
        <:col
          :let={data}
          label="If the claim is sectarian in nature, identify the community targeted by the claim?"
        >
          <%= data.claim_is_sectarian %>
        </:col>
        <:col
          :let={data}
          label="Is the claim targeting a gender? If so, please specify the group targeted."
        >
          <%= data.gender %>
        </:col>
        <:col :let={data} label="Is the content of the question disturbing or triggering?">
          <%= data.content_disturbing %>
        </:col>
        <:col
          :let={data}
          label="If yes to the previous question, did the claim fall under any of the following categories?"
        >
          <%= data.claim_category %>
        </:col>
        <:col
          :let={data}
          label="Did the claim carry a logo similar to that of recognised organisation (Imposter content)"
        >
          <%= data.claim_logo %>
        </:col>
        <:col :let={data} label="If yes, which organisation's logo did it imitate?">
          <%= data.org_logo %>
        </:col>
        <:col
          :let={data}
          label="Was this A.I.-generated misinformation used to frame the image of an individual/organisation in a negative or positive light?"
        >
          <%= data.frame_org %>
        </:col>
        <:col :let={data} label="Medium of content"><%= data.medium_of_content %></:col>
      </.table>
    </div>
    """
  end
end
