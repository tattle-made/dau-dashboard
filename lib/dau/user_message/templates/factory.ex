defmodule DAU.UserMessage.Templates.Factory do
  @moduledoc """
  Map data added to feed_common to appropriate response template

  Responses send to users are standardized using templates. This serves two purposes - reduce burden on the editors
  in composing a response to the user and it adheres to how whatsapp allows sending responses to users after 24 hours.

  What response is sent to a user depends on the following :
  1. Is there an assessment report attached by the DAU secratariat
  2. Are there factcheck articles attached to the query and how many?
  3. Verification status of the query

  ## Example
  alias DAU.Repo
  alias DAU.Feed.Common
  alias DAU.UserMessage.Templates.Factory

  common = Repo.get(Common, 1)
  template = Factory.process(common)
  text = Factory.eval(template)
  "📢 We reviewed this audio/video and found it to be a Deepfake.\n\n🎯You can read our assessment report here: https://report-url\n\n🧠 Please use your discretion in sharing this information.\n\nThank you for reaching out to us. We hope you have a good day ahead. 🙏"
  """
  alias DAU.UserMessage.Templates.Template
  alias DAU.Feed.Common
  require EEx

  # @base_path "lib/dau/user_message/templates/files"
  @base_path "priv/static/gupshup_templates"

  def process(%Common{} = common) do
    common
    |> Template.change()
    |> Template.assign_assessment_report()
    |> Template.assign_factcheck_articles()
    |> Template.assign_verification_status()
    |> Template.assign_language()
    |> Template.assign_template_parameters()
    |> Template.assign_template_name()
    |> Template.assign_valid()
  end

  def eval(%Template{} = template) do
    path_prefix = Application.app_dir(:dau, @base_path)

    try do
      text =
        EEx.eval_file(
          "#{path_prefix}/#{template.meta.template_name}.eex",
          template.meta.template_parameters
        )

      {:ok, String.trim(text)}
      # {:ok, text}
    rescue
      File.Error -> {:error, "There is no template file for this configuration."}
    end
  end
end
