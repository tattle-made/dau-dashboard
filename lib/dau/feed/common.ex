defmodule DAU.Feed.Common do
  alias DAU.UserMessage.Query
  alias DAU.UserMessage.Inbox
  alias DAU.Feed.AssessmentReport
  alias DAU.Feed.Resource
  alias DAU.Feed.Common
  alias DAU.Feed.FactcheckArticle
  use Ecto.Schema
  import Ecto.Changeset

  schema "feed_common" do
    field :status, Ecto.Enum, values: [:published, :in_progress, :not_taken]
    field :media_urls, {:array, :string}
    field :verification_note, :string
    field :tags, {:array, :string}
    field :exact_count, :integer
    field :media_type, Ecto.Enum, values: [:video, :audio, :image, :text, :mixed]
    field :language, Ecto.Enum, values: [:en, :hi, :ta, :te, :und]
    field :taken_by, :string
    field :user_response, :string
    field :sender_number, :string
    field :verification_sop, :string

    field :verification_status, Ecto.Enum,
      values: [
        :deepfake,
        :manipulated,
        :not_manipulated,
        :inconclusive,
        :not_ai_generated,
        :ai_generated,
        :out_of_scope,
        :spam,
        :unsupported_language
      ]

    embeds_many :factcheck_articles, FactcheckArticle, on_replace: :delete

    embeds_many :resources, Resource, on_replace: :delete

    embeds_one :assessment_report, AssessmentReport, on_replace: :delete

    has_many :messages, Inbox, foreign_key: :id

    has_many :queries, Query, foreign_key: :id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(common, attrs \\ %{}) do
    common
    |> cast(attrs, [
      :media_urls,
      :media_type,
      :taken_by,
      :verification_note,
      :tags,
      :status,
      :exact_count,
      :sender_number,
      :user_response,
      :verification_status,
      :language
    ])
    |> validate_required([:media_urls, :media_type, :sender_number])
  end

  def annotation_changeset(common, attrs \\ %{}) do
    common
    |> cast(attrs, [:verification_note, :tags])
  end

  def user_response_label_changeset(common, attrs \\ %{}) do
    common
    |> cast(attrs, [:verification_status])
    |> validate_required([:verification_status])
  end

  def take_up_changeset(common, attrs \\ %{}) do
    common
    |> cast(attrs, [:taken_by])
    |> validate_required([:taken_by])
  end

  def user_response_changeset(common, attrs \\ %{}) do
    common
    |> cast(attrs, [:user_response])
    |> validate_required([:user_response])
  end

  def verification_sop_changeset(%Common{} = common, attrs \\ %{}) do
    common
    |> cast(attrs, [:verification_sop])
    |> validate_required([:verification_sop])
  end

  def query_with_resource_changeset(common, new_resource, attrs \\ %{}) do
    common
    |> cast(attrs, [
      :media_urls,
      :media_type,
      :taken_by,
      :verification_note,
      :tags,
      :status,
      :exact_count,
      :sender_number,
      :user_response,
      :verification_status
    ])
    |> validate_required([:media_urls, :media_type, :sender_number])
    |> put_embed(:resources, [new_resource | common.resources])
    |> cast_embed(:resources, required: true)
  end

  def query_with_assessment_report_changeset(common, assessment_report, attrs \\ %{}) do
    common
    |> cast(attrs, [
      :media_urls,
      :media_type,
      :taken_by,
      :verification_note,
      :tags,
      :status,
      :exact_count,
      :sender_number,
      :user_response,
      :verification_status
    ])
    |> put_embed(:assessment_report, assessment_report)
    |> cast_embed(:assessment_report, required: true)
  end

  def query_with_factcheck_article(common, factcheck_article, attrs \\ %{}) do
    common
    |> cast(attrs, [
      :media_urls,
      :media_type,
      :taken_by,
      :verification_note,
      :tags,
      :status,
      :exact_count,
      :sender_number,
      :user_response,
      :verification_status
    ])
    |> put_embed(:factcheck_articles, [factcheck_article | common.factcheck_articles])
    |> cast_embed(:factcheck_articles, required: true)
  end

  # defp set_default_verification_note_if_empty(changeset) do
  #   default_text = """
  #   Identify claim or hoax
  #   Confirm it is fact checkable
  #   Choose what you will focus on
  #   Find the fact
  #   Correct the record
  #   """

  #   case get_field(changeset, :verification_sop) do
  #     nil -> put_change(changeset, :verification_sop, default_text)
  #     _ -> changeset
  #   end
  # end
end
