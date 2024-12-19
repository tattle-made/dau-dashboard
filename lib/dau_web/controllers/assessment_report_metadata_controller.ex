defmodule DAUWeb.AssessmentReportMetadataController do
  alias DAU.Feed.AssessmentReportMetadataRepository
  use DAUWeb, :controller

  @theme_radio_labels [
    {1,
     "Civic Issues (matters of infrastructure, eg., potholes, accidents, breakdown of infrastructure)"},
    {2,
     "Government Schemes (related to policies or schemes e.g., generative text misrepresenting policy priorities)"},
    {3,
     "Political (includes matters dealing with politicians or political parties e.g., campaigns, leader speeches, party worker deeds etc.)"},
    {4,
     "Communal (in cases where negative sentiments are associated with religion/ethnic identity)"},
    {5,
     "Defense (matters tied to the Indian defense forces e.g., scripted imagery of military exercises)"},
    {6, "Crime (Robbery/ murder/ cyber crime/ bribery/raids)"},
    {7, "Economy (Includes budget, taxes, GST, road cess, Petrol & LPG prices)"},
    {8, "Scams (Job scams/ financial scams & phishing attempts/ Promises of car et al)"},
    {9, "Health (health hoaxes, quack advice e.g., Dr Naresh Trehan Deepfake)"},
    {10, "IT & Science (tech related matters e.g., cybertruck accidents)"},
    {11, "Entertainment (deals with celeb conduct, movie related matters)"},
    {12, "Sports (deals with sporting events, sportsman conduct)"},
    {13, "Tragedy (Freak incidents, natural disasters, loss of lives e.g.,)"},
    {14,
     "Foreign Affairs (matters pertaining to other countries including, internal politics/policies/economy)"},
    {15, "Judiciary (Court orders/ news about some judge/ pending cases)"},
    {16,
     "Religion (opposed to 'communal', this one is to be used in cases of positive sentiment accompanying claims)"},
    {17, "Culture (similar to above, but more generalised like cuisine, dance form etc.)"},
    {18,
     "International Boundary Dispute (e.g., secession, incursions, skirmishes around border, eg., Indo-China, Indo-Pakistan)"},
    {19, "Business (Generative content targeting companies and/or their figureheads)"},
    {20, "Influencer/Public Figure"}
  ]
  @yes_no_labels [{1, "Yes"}, {2, "No"}]
  @claim_categories [
    {1, "Graphic"},
    {2, "Pornographic/Sexual"},
    {3, "Violent"},
    {4, "Expletives"}
  ]
  @pos_neg_labels [{1, "Positive"}, {2, "Negative"}, {3, "Neutral"}, {4, "Inconclusive"}]
  @language_labels [
    {:en, "English"},
    {:hi, "Hindi"},
    {:ta, "Tamil"},
    {:te, "Telugu"},
    {:ur, "Urdu"},
    {:mr, "Marathi"},
    {:bn, "Bangla"}
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

    case AssessmentReportMetadataRepository.create(form_data) do
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
      AssessmentReportMetadataRepository.get(id)

    changeset = Ecto.Changeset.change(assessment_report_metadata)
    form = Phoenix.HTML.FormData.to_form(changeset, as: :my_form)
    render(conn, :edit, form: form, id: id)
  end

  def update(conn, params) do
    id = params["id"]
    form_data = params["my_form"]

    case AssessmentReportMetadataRepository.update(id, form_data) do
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

    case AssessmentReportMetadataRepository.delete(id) do
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
    metadata = AssessmentReportMetadataRepository.fetch_all()

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

    translate_label = fn labels, key ->
      case Enum.find(labels, fn {label_key, _value} -> label_key == key end) do
        {_key, value} -> value
        nil -> ""
      end
    end

    transformed_metadata =
      Enum.map(metadata, fn data ->
        %{
          data
          | primary_theme: translate_label.(@theme_radio_labels, data.primary_theme),
            secondary_theme: translate_label.(@theme_radio_labels, data.secondary_theme),
            gender: if(data.gender, do: translate_gender.(data.gender), else: ""),
            content_disturbing: translate_label.(@yes_no_labels, data.content_disturbing),
            claim_category: translate_label.(@claim_categories, data.claim_category),
            claim_logo: translate_label.(@yes_no_labels, data.claim_logo),
            frame_org: translate_label.(@pos_neg_labels, data.frame_org),
            language: translate_label.(@language_labels, data.language),
            medium_of_content: translate_label.(@medium_of_content_labels, data.medium_of_content)
        }
        |> Map.put_new(
          :assessment_report_url,
          AssessmentReportMetadataRepository.get_assessment_report_url(data.feed_common_id) || ""
        )
      end)

    render(conn, :fetch, metadata: transformed_metadata)
  end
end
