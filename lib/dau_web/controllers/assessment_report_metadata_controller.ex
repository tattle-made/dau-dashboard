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
end
