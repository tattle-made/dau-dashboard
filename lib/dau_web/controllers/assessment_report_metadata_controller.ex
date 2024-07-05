defmodule DAUWeb.AssessmentReportMetadataController do
  alias DAU.Feed.AssessmentReportMetadata
  use DAUWeb, :controller

  @theme_radio_labels [
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
  @yes_no_labels ["Yes", "No"]
  @claim_categories ["Graphic", "Pornographic/Sexual", "Violent", "Expletives"]
  @pos_neg_labels ["Positive", "Negative", "Neutral", "Inconclusive"]
  @language_labels [
    {:en, "English"},
    {:hi, "Hindi"},
    {:ta, "Tamil"},
    {:te, "Telugu"}
  ]
  @gender_labels [
    {"male", "Male"},
    {"female", "Female"},
    {"trans_male", "Male (Trans Male)"},
    {"trans_female", "Female (Trans Female)"},
    {"lgbqia", "LGBQIA+"}
  ]
  @medium_of_content_labels [
    {:video, "Video"},
    {:audio, "Audio"},
    {:link, "Link"}
  ]

  def static_labels_data() do
    %{
      yes_no_labels: @yes_no_labels,
      theme_radio_labels: @theme_radio_labels,
      claim_categories: @claim_categories,
      pos_neg_labels: @pos_neg_labels,
      language_labels: @language_labels,
      gender_labels: @gender_labels,
      medium_of_content_labels: @medium_of_content_labels
    }
  end

  def show(conn, params) do
    form = %{
      target: "",
      language: "",
      primary_theme: "",
      secondary_theme: "",
      third_theme: "",
      claim_is_sectarian: "",
      gender: [],
      content_disturbing: "",
      claim_category: "",
      claim_logo: "",
      org_logo: "",
      frame_org: "",
      medium_of_content: ""
    }

    form = Phoenix.HTML.FormData.to_form(form, as: :my_form)
    render(conn, :show, form: form, id: params["id"])
  end

  def create(conn, params) do
    id = params["id"]
    form_data = params["my_form"]
    form_data = Map.put(form_data, "feed_common_id", id)

    case AssessmentReportMetadata.create_assessment_report_metadata(form_data) do
      {:ok, _metadata} ->
        conn
        |> put_flash(:info, "Assessment Report Metadata Added!")
        |> redirect(to: "/demo/query/#{id}")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error creating Assessment Report Metadata://.")
        |> render(:show, form: changeset, id: id)
    end

    redirect(conn, to: "/demo/query/#{id}")
  end

  def edit(conn, params) do
    id = params["id"]

    assessment_report_metadata =
      AssessmentReportMetadata.get_assessment_report_metadata_by_common_id(id)

    changeset = Ecto.Changeset.change(assessment_report_metadata)
    form = Phoenix.HTML.FormData.to_form(changeset, as: :my_form)
    render(conn, :edit, form: form, id: id)
  end

  def update(conn, params) do
    id = params["id"]
    form_data = params["my_form"]

    case AssessmentReportMetadata.update_assessment_report_metadata(id, form_data) do
      {:ok, _metadata} ->
        conn
        |> put_flash(:info, "Assessment Report Metadata Updated.")
        |> redirect(to: "/demo/query/#{id}")

      {:error, changeset} ->
        conn
        |> put_flash(:error, "Error Updating Assessment Report Metadata://.")
        |> render(:edit, form: changeset, id: id)
    end
  end

  def delete(conn, params) do
    id = params["id"]

    case AssessmentReportMetadata.delete_assessment_report_metadata(id) do
      {:ok, _metadata} ->
        conn
        # |> put_flash(:info, "assessment report metadata deleted successfully.")
        |> redirect(to: "/demo/query/#{id}")

      {:error, :not_found} ->
        conn
        # |> put_flash(:error, "Error deleting assessment report metadata.")
        |> redirect(to: "/demo/query/#{id}")
    end
  end

  def fetch(conn, _params) do
    metadata = AssessmentReportMetadata.fetch_all_assessment_report_metadata()

    translate_gender = fn gender_list ->
      gender_list
      |> Enum.map(fn gender ->
        case Enum.find(@gender_labels, fn {key, _value} -> key == gender end) do
          {_key, value} -> value
          nil -> ""
        end
      end)
      |> Enum.join(", ")
    end

    transformed_metadata =
      Enum.map(metadata, fn data ->
        %{
          data
          | primary_theme:
              if(data.primary_theme,
                do: Enum.at(@theme_radio_labels, data.primary_theme),
                else: ""
              ),
            secondary_theme:
              if(data.secondary_theme,
                do: Enum.at(@theme_radio_labels, data.secondary_theme),
                else: ""
              ),
            gender: if(data.gender, do: translate_gender.(data.gender), else: ""),
            content_disturbing:
              if(data.content_disturbing,
                do: Enum.at(@yes_no_labels, data.content_disturbing),
                else: ""
              ),
            claim_category:
              if(data.claim_category,
                do: Enum.at(@claim_categories, data.claim_category),
                else: ""
              ),
            claim_logo:
              if(data.claim_logo, do: Enum.at(@yes_no_labels, data.claim_logo), else: ""),
            frame_org: if(data.frame_org, do: Enum.at(@pos_neg_labels, data.frame_org), else: ""),
            language: Keyword.get(@language_labels, data.language, ""),
            medium_of_content: Keyword.get(@medium_of_content_labels, data.medium_of_content, "")
        }
        |> Map.put_new(
          :assessment_report_url,
          AssessmentReportMetadata.get_assessment_report_url_by_common_id(data.feed_common_id) ||
            ""
        )
      end)

    render(conn, :fetch, metadata: transformed_metadata)
  end
end
