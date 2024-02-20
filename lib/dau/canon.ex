defmodule DAU.Canon do
  @moduledoc """
  The Canon context.
  """

  import Ecto.Query, warn: false
  alias DAU.Repo

  alias DAU.Canon.ManipulatedMedia

  @doc """
  Returns the list of manipulated_media.

  ## Examples

      iex> list_manipulated_media()
      [%ManipulatedMedia{}, ...]

  """
  def list_manipulated_media do
    Repo.all(ManipulatedMedia)
  end

  @doc """
  Gets a single manipulated_media.

  Raises `Ecto.NoResultsError` if the Manipulated media does not exist.

  ## Examples

      iex> get_manipulated_media!(123)
      %ManipulatedMedia{}

      iex> get_manipulated_media!(456)
      ** (Ecto.NoResultsError)

  """
  def get_manipulated_media!(id), do: Repo.get!(ManipulatedMedia, id)

  @doc """
  Creates a manipulated_media.

  ## Examples

      iex> create_manipulated_media(%{field: value})
      {:ok, %ManipulatedMedia{}}

      iex> create_manipulated_media(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_manipulated_media(attrs \\ %{}) do
    %ManipulatedMedia{}
    |> ManipulatedMedia.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a manipulated_media.

  ## Examples

      iex> update_manipulated_media(manipulated_media, %{field: new_value})
      {:ok, %ManipulatedMedia{}}

      iex> update_manipulated_media(manipulated_media, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_manipulated_media(%ManipulatedMedia{} = manipulated_media, attrs) do
    manipulated_media
    |> ManipulatedMedia.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a manipulated_media.

  ## Examples

      iex> delete_manipulated_media(manipulated_media)
      {:ok, %ManipulatedMedia{}}

      iex> delete_manipulated_media(manipulated_media)
      {:error, %Ecto.Changeset{}}

  """
  def delete_manipulated_media(%ManipulatedMedia{} = manipulated_media) do
    Repo.delete(manipulated_media)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking manipulated_media changes.

  ## Examples

      iex> change_manipulated_media(manipulated_media)
      %Ecto.Changeset{data: %ManipulatedMedia{}}

  """
  def change_manipulated_media(%ManipulatedMedia{} = manipulated_media, attrs \\ %{}) do
    ManipulatedMedia.changeset(manipulated_media, attrs)
  end

  alias DAU.Canon.FactcheckArticle

  @doc """
  Returns the list of factcheck_articles.

  ## Examples

      iex> list_factcheck_articles()
      [%FactcheckArticle{}, ...]

  """
  def list_factcheck_articles do
    Repo.all(FactcheckArticle)
  end

  @doc """
  Gets a single factcheck_article.

  Raises `Ecto.NoResultsError` if the Factcheck article does not exist.

  ## Examples

      iex> get_factcheck_article!(123)
      %FactcheckArticle{}

      iex> get_factcheck_article!(456)
      ** (Ecto.NoResultsError)

  """
  def get_factcheck_article!(id), do: Repo.get!(FactcheckArticle, id)

  @doc """
  Creates a factcheck_article.

  ## Examples

      iex> create_factcheck_article(%{field: value})
      {:ok, %FactcheckArticle{}}

      iex> create_factcheck_article(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_factcheck_article(attrs \\ %{}) do
    %FactcheckArticle{}
    |> FactcheckArticle.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a factcheck_article.

  ## Examples

      iex> update_factcheck_article(factcheck_article, %{field: new_value})
      {:ok, %FactcheckArticle{}}

      iex> update_factcheck_article(factcheck_article, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_factcheck_article(%FactcheckArticle{} = factcheck_article, attrs) do
    factcheck_article
    |> FactcheckArticle.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a factcheck_article.

  ## Examples

      iex> delete_factcheck_article(factcheck_article)
      {:ok, %FactcheckArticle{}}

      iex> delete_factcheck_article(factcheck_article)
      {:error, %Ecto.Changeset{}}

  """
  def delete_factcheck_article(%FactcheckArticle{} = factcheck_article) do
    Repo.delete(factcheck_article)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking factcheck_article changes.

  ## Examples

      iex> change_factcheck_article(factcheck_article)
      %Ecto.Changeset{data: %FactcheckArticle{}}

  """
  def change_factcheck_article(%FactcheckArticle{} = factcheck_article, attrs \\ %{}) do
    FactcheckArticle.changeset(factcheck_article, attrs)
  end
end
