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

    checkbox_labels = [
      "Male",
      "Female",
      "Male (Trans Male)",
      "Female (Trans Female)",
      "LGBQIA+"
    ]

    ~H"""
    <div>
      <.simple_form for={@form} action={"/demo/query/#{@id}/assessment-report/metadata"}>
        <.input field={@form[:link_of_ar]} label="Link Of Assessment Report" />
        <.input field={@form[:who_is_post_targeting]} label="Who is the post/claim targeting?" />
        <.input
          field={@form[:language_used]}
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
            <%= for label <- theme_radio_labels do %>
              <.input_radio
                name="primary_theme_radio"
                id={"sec_theme_radio_#{label}"}
                label={label}
                selection={@form[:primary_theme].value}
              />
            <% end %>
            <%!-- <.input field={@form[:primary_theme]} type="radio" label="Health" value="health" /> --%>
          </div>
        </div>
        <.radio_group field={@form[:tip]}>
          <:radio value="0">No Tip</:radio>
          <:radio value="10">10%</:radio>
          <:radio value="20">20%</:radio>
        </.radio_group>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Secondary theme of that claim
          </label>
          <div class="mt-2">
            <%= for label <- theme_radio_labels do %>
              <.input_radio
                name="secondary_theme_radio"
                id={"sec_theme_radio_" <> label}
                label={label}
                selection={@form[:secondary_theme].value}
              />
            <% end %>
          </div>
        </div>
        <.input
          field={@form[:follow_up]}
          label="Follow-up to previous question, is there a third claim category that you'd like to mention?"
        />
        <.input
          field={@form[:claim_is_sectarian]}
          label="If the claim is sectarian in nature, identify the community targeted by the claim?"
        />
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Is the claim targeting a gender? If so, please specify the group targeted.
          </label>
          <div class="mt-2">
            <%!-- <%= for label <- checkbox_labels do %>
              <.input
                field={@form[:gender]}
                type="checkbox"
                name="gender"
                id={label}
                value={label}
                label={label}
              />
              <.checkbox
                name="gender"
                id={label}
                label={label}
                group="gender-group"
                selection={@form[:gender].value || []}
              />
            <% end %> --%>
            <%= checkbox(%{
              id: "gender-male",
              label: "Male",
              name: "gender-male",
              group: "male-group",
              checked: false,
              text_color: "text-zinc-800",
              selection: [],
              text_decoration: "",
              __changed__: nil
            }) %>
            <%= checkbox(%{
              id: "gender-female",
              label: "Female",
              name: "gender-female",
              group: "female-group",
              checked: false,
              text_color: "text-zinc-800",
              selection: [],
              text_decoration: "",
              __changed__: nil
            }) %>
            <%= checkbox(%{
              id: "gender-trans-male",
              label: "Male (Trans Male)",
              name: "gender-trans-male",
              group: "trans-male-group",
              checked: false,
              text_color: "text-zinc-800",
              selection: [],
              text_decoration: "",
              __changed__: nil
            }) %>
            <%= checkbox(%{
              id: "gender-trans-female",
              label: "Female (Trans Female)",
              name: "gender-trans-female",
              group: "trans-female-group",
              checked: false,
              text_color: "text-zinc-800",
              selection: [],
              text_decoration: "",
              __changed__: nil
            }) %>
            <%= checkbox(%{
              id: "gender-lgbtqia",
              label: "LGBQIA+",
              name: "gender-lgbtqia",
              group: "lgbtqia-group",
              checked: false,
              text_color: "text-zinc-800",
              selection: [],
              text_decoration: "",
              __changed__: nil
            }) %>
          </div>
        </div>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Is the content of the question disturbing or triggering?
          </label>
          <div class="mt-2">
            <.input_radio
              name="yes_content_disturbing_question"
              id="yes_content_disturbing_question"
              label="Yes"
              selection={@form[:content_disturbing_question].value}
            />
            <.input_radio
              name="no_content_disturbing_question"
              id="no_content_disturbing_question"
              label="No"
              selection={@form[:content_disturbing_question].value}
            />
          </div>
        </div>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            If yes to the previous question, did the claim fall under any of the following categories?
          </label>
          <div class="mt-2">
            <.input_radio
              name="prev_question_claim"
              id="graphic_prev_question_claim"
              label="Graphic"
              selection={@form[:prev_question_claim].value}
            />
            <.input_radio
              name="prev_question_claim"
              id="ps_prev_question_claim"
              label="Pornographic/Sexual"
              selection={@form[:prev_question_claim].value}
            />
            <.input_radio
              name="prev_question_claim"
              id="violent_prev_question_claim"
              label="Violent"
              selection={@form[:prev_question_claim].value}
            />
            <.input_radio
              name="prev_question_claim"
              id="expletives_prev_question_claim"
              label="Expletives"
              selection={@form[:prev_question_claim].value}
            />
          </div>
        </div>
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Did the claim carry a logo similar to that of recognised organisation (Imposter content)
          </label>
          <div class="mt-2">
            <.input_radio
              name="yes_claim_logo"
              id="yes_claim_logo"
              label="Yes"
              selection={@form[:claim_logo].value}
            />
            <.input_radio
              name="no_claim_logo"
              id="no_claim_logo"
              label="No"
              selection={@form[:claim_logo].value}
            />
          </div>
        </div>
        <.input
          field={@form[:which_org_imitate]}
          label="If yes, which organisation's logo did it imitate? "
        />
        <div>
          <label class="block text-sm font-semibold leading-6 text-zinc-800">
            Was this A.I.-generated misinformation used to frame the image of an individual/organisation in a negative or positive light?
          </label>
          <div class="mt-2">
            <.input_radio
              name="is_ai_gen"
              id="pos_is_ai_gen"
              label="Positive"
              selection={@form[:is_ai_gen].value}
            />
            <.input_radio
              name="is_ai_gen"
              id="neg_is_ai_gen"
              label="Negative"
              selection={@form[:is_ai_gen].value}
            />
            <.input_radio
              name="is_ai_gen"
              id="neutral_is_ai_gen"
              label="Neutral"
              selection={@form[:is_ai_gen].value}
            />
            <.input_radio
              name="is_ai_gen"
              id="inconclusive_is_ai_gen"
              label="Inconclusive"
              selection={@form[:is_ai_gen].value}
            />
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
