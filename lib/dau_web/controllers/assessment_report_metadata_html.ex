defmodule DAUWeb.AssessmentReportMetadataHTML do
  use DAUWeb, :html

  def show(assigns) do
    ~H"""
    <div>
      <.simple_form for={@form} action={"/demo/query/#{@id}/assessment-report/metadata"}>
        <.input field={@form[:email]} label="Email" />
        <.input field={@form[:username]} label="Username" />
        <:actions>
          <.button>Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end
end
