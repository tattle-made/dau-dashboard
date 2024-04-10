defmodule DAU.UserMessage.Templates.Template do
  @moduledoc """
  Transformations to extract structured data out of feed_common and pass to templates

  %Common{}
  |> Template.change()
  |> Template.assign_assessment_report()
  |> Template.assign_factcheck_articles()
  |> Template.assign_verification_status()
  |> Template.assign_template_parameters()
  |> Template.assign_template_name()
  |> Template.assign_valid()
  """
  alias DAU.UserMessage.Templates.Template
  alias DAU.Feed.Common
  defstruct [:data, :meta, :function, :template_name]

  def change(%Common{} = common) do
    %Template{}
    |> Map.put(:data, common)
    |> Map.put(:meta, %{})
    |> Map.put(:function, nil)
  end

  def assign_assessment_report(%Template{} = template) do
    data = template.data
    value = Map.get(data, :assessment_report, nil)
    new_meta = Map.put(template.meta, :assessment_report, value)
    Map.put(template, :meta, new_meta)
  end

  def assign_factcheck_articles(%Template{} = template) do
    data = template.data
    factcheck_articles = Map.get(data, :factcheck_articles, [])

    pattern =
      ~r/boomlive|factcrescendo|factly|indiatoday|thelogicalindian|logicallyfacts|newschecker|newsmeter|newsmobile|thequint|thip|vishvasnews/

    value =
      Enum.map(factcheck_articles, fn article ->
        domain =
          case Regex.run(pattern, article.url) do
            nil -> "_"
            matches -> matches |> hd
          end

        %{
          domain: domain,
          url: article.url
        }
      end)

    new_meta = Map.put(template.meta, :factcheck_articles, value)

    Map.put(template, :meta, new_meta)
  end

  def assign_verification_status(%Template{} = template) do
    data = template.data
    value = Map.get(data, :verification_status, nil)
    new_meta = Map.put(template.meta, :verification_status, value)
    Map.put(template, :meta, new_meta)
  end

  def assign_template_name(%Template{} = template) do
    name_parts = [
      template_name_label(:verification_status, template),
      template_name_label(:assessment_report, template),
      template_name_label(:factcheck_articles, template)
    ]

    name = Enum.reduce(name_parts, "", fn acc, name -> "#{name}_#{acc}" end)
    name = name |> String.slice(1..-1)

    new_meta = Map.put(template.meta, :template_name, name)
    Map.put(template, :meta, new_meta)
  end

  defp template_name_label(:verification_status, %Template{meta: meta}) do
    Atom.to_string(meta.verification_status)
  end

  defp template_name_label(:factcheck_articles, %Template{meta: meta}) do
    case length(meta.factcheck_articles) do
      0 -> "0fc"
      1 -> "1fc"
      2 -> "2fc"
      _ -> raise "Too many fact check articles"
    end
  end

  defp template_name_label(:assessment_report, %Template{meta: meta}) do
    case meta.assessment_report do
      nil -> "wo_ar"
      _ -> "w_ar"
    end
  end

  def assign_valid(%Template{meta: %{template_name: template_name}} = template) do
    is_valid =
      Enum.member?(
        [
          "deepfake_w_ar_0fc",
          "deepfake_wo_ar_2fc",
          "manipulated_wo_ar_2fc",
          "manipulated_w_ar_0fc",
          "not_manipulated_wo_ar_0fc",
          "not_manipualted_wo_ar_2fc",
          "inconclusive_w_ar_0fc",
          "out_of_scope",
          "not_ai_gen_wo_ar_0fc",
          "not_ai_gen_wo_ar_2fc"

          # "deepfake_wo_ar_1fc",
          # "not_manipulated_wo_ar_1fc",
          # "not_ai_gen_wo_ar_1fc",
          # "unsupported_language_wo_ar_0fc",
          # "ai_generated_wo_ar_0fc",
          # "ai_generated_w_ar_0fc",
          # "ai_generated_wo_ar_1fc",
          # "ai_generated_wo_ar_2fc",
          # "spam_wo_ar_0fc"
        ],
        template_name
      )

    new_meta = Map.put(template.meta, :valid, is_valid)
    Map.put(template, :meta, new_meta)
  end

  def assign_template_parameters(%Template{meta: meta} = template) do
    map_to_keywords = Enum.map(meta, fn {k, v} -> {k, v} end)

    new_meta = Map.put(template.meta, :template_parameters, map_to_keywords)
    Map.put(template, :meta, new_meta)
  end
end
