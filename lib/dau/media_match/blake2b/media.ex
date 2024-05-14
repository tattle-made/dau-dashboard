defmodule DAU.MediaMatch.Blake2B.Media do
  @moduledoc """
  A media item is uniquely identified with its hash value and
  the language of the user.
  """
  alias DAU.MediaMatch.Blake2B.Media
  defstruct [:hash, :language, :inbox_id]

  def build() do
    %Media{}
  end

  def set_inbox_id(%Media{} = media, inbox_id) do
    %{media | inbox_id: inbox_id}
  end

  def set_hash(%Media{} = media, hash) do
    %{media | hash: hash}
  end

  def set_language(%Media{} = media, language) do
    %{media | language: language}
  end
end
