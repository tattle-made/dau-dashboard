defmodule DAUWeb.AssessmentReportMetadataController do
  alias DAU.Feed.AssessmentReportMetadata
  use DAUWeb, :controller

  def show(conn, params) do
    form = %{
      link: "",
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
    IO.inspect(form_data, label: "SUBMITTED VALUES")

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
    IO.inspect(form)

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

    # Translation maps
    language_labels = %{
      en: "English",
      hi: "Hindi",
      ta: "Tamil",
      te: "Telugu",
      und: ""
    }

    theme_labels = [
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

    gender_labels = %{
      "male" => "Male",
      "female" => "Female",
      "trans_male" => "Male (Trans Male)",
      "trans_female" => "Female (Trans Female)",
      "lgbqia" => "LGBQIA+"
    }

    medium_of_content_labels = %{
      video: "Video",
      audio: "Audio",
      link: "Link"
    }

    translate_gender = fn gender_list ->
      Enum.map(gender_list, &Map.get(gender_labels, &1)) |> Enum.join(", ")
    end

    transformed_metadata =
      Enum.map(metadata, fn data ->
        %{
          data
          | primary_theme: Enum.at(theme_labels, data.primary_theme),
            secondary_theme: Enum.at(theme_labels, data.secondary_theme),
            gender: translate_gender.(data.gender),
            content_disturbing: Enum.at(yes_no_labels, data.content_disturbing),
            claim_category: Enum.at(claim_categories, data.claim_category),
            claim_logo: Enum.at(yes_no_labels, data.claim_logo),
            frame_org: Enum.at(pos_neg_labels, data.frame_org),
            language: Map.get(language_labels, data.language),
            medium_of_content: Map.get(medium_of_content_labels, data.medium_of_content)
        }
      end)

    render(conn, :fetch, metadata: transformed_metadata)
  end
end
