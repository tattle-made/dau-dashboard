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
  defstruct [:data, :meta]

  @type t :: %__MODULE__{
          data: Common.t(),
          meta: %{}
        }

  def change(%Common{} = common) do
    %Template{}
    |> Map.put(:data, common)
    |> Map.put(:meta, %{})
  end

  def assign_assessment_report(%Template{} = template) do
    data = template.data
    value = Map.get(data, :assessment_report)

    new_meta =
      case value do
        nil -> Map.put(template.meta, :assessment_report, nil)
        %{url: url} -> Map.put(template.meta, :assessment_report, url)
      end

    Map.put(template, :meta, new_meta)
  end

  def assign_factcheck_articles(%Template{} = template) do
    data = template.data
    factcheck_articles = Map.get(data, :factcheck_articles, [])

    pattern =
      ~r/boomlive|factcrescendo|factly|indiatoday|thelogicalindian|logicallyfacts|newschecker|newsmeter|newsmobile|thequint|thip|vishvasnews/

    name_map = %{
      "boomlive" => "Boomlive",
      "vishvasnews" => "Vishvas News",
      "factly" => "Factly",
      "thip" => "THIP",
      "newschecker" => "Newschecker",
      "factcrescendo" => "Fact Crescendo",
      "indiatoday" => "India Today",
      "newsmobile" => "Newsmobile",
      "thequint" => "Quint",
      "logicallyfacts" => "Logically Facts",
      "newsmeter" => "Newsmeter"
    }

    value =
      Enum.filter(factcheck_articles, fn article ->
        Map.get(article, :approved)
      end)
      |> Enum.map(fn article ->
        domain =
          case Regex.run(pattern, article.url) do
            nil -> "_"
            matches -> matches |> hd
          end

        %{
          domain: name_map[domain],
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
      template_name_label(:factcheck_articles, template),
      template_name_label(:language, template)
    ]

    name = Enum.reduce(name_parts, "", fn acc, name -> "#{name}_#{acc}" end)
    name = name |> String.slice(1..-1)

    new_meta = Map.put(template.meta, :template_name, name)
    Map.put(template, :meta, new_meta)
  end

  @spec template_name_label(atom(), Template.t()) :: String.t()
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

  defp template_name_label(:language, %Template{meta: meta}) do
    Atom.to_string(meta.language)
  end

  def assign_valid(%Template{meta: %{template_name: template_name}} = template) do
    is_valid =
      Enum.member?(
        [
          "deepfake_w_ar_0fc_en",
          "deepfake_wo_ar_1fc_en",
          "deepfake_wo_ar_2fc_en",
          "manipulated_wo_ar_1fc_en",
          "manipulated_wo_ar_2fc_en",
          "manipulated_w_ar_0fc_en",
          "manipulated_wo_ar_0fc_en",
          "not_manipulated_wo_ar_0fc_en",
          "not_manipulated_wo_ar_1fc_en",
          "not_manipulated_wo_ar_2fc_en",
          "inconclusive_w_ar_0fc_en",
          "out_of_scope_wo_ar_0fc_en",
          "not_ai_generated_wo_ar_0fc_en",
          "not_ai_generated_wo_ar_1fc_en",
          "not_ai_generated_wo_ar_2fc_en",
          "unsupported_language_wo_ar_0fc_en",
          "ai_generated_wo_ar_0fc_en",
          "ai_generated_w_ar_0fc_en",
          "ai_generated_wo_ar_1fc_en",
          "ai_generated_wo_ar_2fc_en",
          "cheapfake_wo_ar_0fc_en",
          "cheapfake_w_ar_0fc_en",
          "cheapfake_wo_ar_1fc_en",
          "cheapfake_wo_ar_2fc_en",
          "deepfake_w_ar_0fc_hi",
          "deepfake_wo_ar_1fc_hi",
          "deepfake_wo_ar_2fc_hi",
          "manipulated_w_ar_0fc_hi",
          "manipulated_wo_ar_1fc_hi",
          "manipulated_wo_ar_2fc_hi",
          "manipulated_wo_ar_0fc_hi",
          "not_manipulated_wo_ar_0fc_hi",
          "not_manipulated_wo_ar_1fc_hi",
          "not_manipulated_wo_ar_2fc_hi",
          "ai_generated_wo_ar_0fc_hi",
          "ai_generated_w_ar_0fc_hi",
          "ai_generated_wo_ar_1fc_hi",
          "ai_generated_wo_ar_2fc_hi",
          "not_ai_generated_wo_ar_0fc_hi",
          "not_ai_generated_wo_ar_1fc_hi",
          "not_ai_generated_wo_ar_2fc_hi",
          "inconclusive_w_ar_0fc_hi",
          "out_of_scope_wo_ar_0fc_hi",
          "unsupported_language_wo_ar_0fc_hi",
          "cheapfake_wo_ar_0fc_hi",
          "cheapfake_w_ar_0fc_hi",
          "cheapfake_wo_ar_1fc_hi",
          "cheapfake_wo_ar_2fc_hi",
          "deepfake_w_ar_0fc_ta",
          "deepfake_wo_ar_1fc_ta",
          "deepfake_wo_ar_2fc_ta",
          "manipulated_w_ar_0fc_ta",
          "manipulated_wo_ar_1fc_ta",
          "manipulated_wo_ar_2fc_ta",
          "manipulated_wo_ar_0fc_ta",
          "not_manipulated_wo_ar_0fc_ta",
          "not_manipulated_wo_ar_1fc_ta",
          "not_manipulated_wo_ar_2fc_ta",
          "ai_generated_wo_ar_0fc_ta",
          "ai_generated_w_ar_0fc_ta",
          "ai_generated_wo_ar_1fc_ta",
          "ai_generated_wo_ar_2fc_ta",
          "not_ai_generated_wo_ar_0fc_ta",
          "not_ai_generated_wo_ar_1fc_ta",
          "not_ai_generated_wo_ar_2fc_ta",
          "inconclusive_w_ar_0fc_ta",
          "out_of_scope_wo_ar_0fc_ta",
          "unsupported_language_wo_ar_0fc_ta",
          "cheapfake_wo_ar_0fc_ta",
          "cheapfake_w_ar_0fc_ta",
          "cheapfake_wo_ar_1fc_ta",
          "cheapfake_wo_ar_2fc_ta",
          "deepfake_w_ar_0fc_te",
          "deepfake_wo_ar_1fc_te",
          "deepfake_wo_ar_2fc_te",
          "manipulated_w_ar_0fc_te",
          "manipulated_wo_ar_1fc_te",
          "manipulated_wo_ar_2fc_te",
          "manipulated_wo_ar_0fc_te",
          "not_manipulated_wo_ar_0fc_te",
          "not_manipulated_wo_ar_1fc_te",
          "not_manipulated_wo_ar_2fc_te",
          "ai_generated_wo_ar_0fc_te",
          "ai_generated_w_ar_0fc_te",
          "ai_generated_wo_ar_1fc_te",
          "ai_generated_wo_ar_2fc_te",
          "not_ai_generated_wo_ar_0fc_te",
          "not_ai_generated_wo_ar_1fc_te",
          "not_ai_generated_wo_ar_2fc_te",
          "inconclusive_w_ar_0fc_te",
          "out_of_scope_wo_ar_0fc_te",
          "unsupported_language_wo_ar_0fc_te",
          "cheapfake_wo_ar_0fc_te",
          "cheapfake_w_ar_0fc_te",
          "cheapfake_wo_ar_1fc_te",
          "cheapfake_wo_ar_2fc_te"
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

  def assign_language(%Template{} = template) do
    data = template.data
    value = Map.get(data, :language, :en) || :en
    new_meta = Map.put(template.meta, :language, value)
    Map.put(template, :meta, new_meta)
  end

  def valid?(%Template{} = template) do
    template.meta.valid
  end
end
