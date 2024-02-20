defmodule DAU.CanonTest do
  use DAU.DataCase

  alias DAU.Canon

  describe "manipulated_media" do
    alias DAU.Canon.ManipulatedMedia

    import DAU.CanonFixtures

    @invalid_attrs %{description: nil, url: nil}

    test "list_manipulated_media/0 returns all manipulated_media" do
      manipulated_media = manipulated_media_fixture()
      assert Canon.list_manipulated_media() == [manipulated_media]
    end

    test "get_manipulated_media!/1 returns the manipulated_media with given id" do
      manipulated_media = manipulated_media_fixture()
      assert Canon.get_manipulated_media!(manipulated_media.id) == manipulated_media
    end

    test "create_manipulated_media/1 with valid data creates a manipulated_media" do
      valid_attrs = %{description: "some description", url: "some url"}

      assert {:ok, %ManipulatedMedia{} = manipulated_media} = Canon.create_manipulated_media(valid_attrs)
      assert manipulated_media.description == "some description"
      assert manipulated_media.url == "some url"
    end

    test "create_manipulated_media/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Canon.create_manipulated_media(@invalid_attrs)
    end

    test "update_manipulated_media/2 with valid data updates the manipulated_media" do
      manipulated_media = manipulated_media_fixture()
      update_attrs = %{description: "some updated description", url: "some updated url"}

      assert {:ok, %ManipulatedMedia{} = manipulated_media} = Canon.update_manipulated_media(manipulated_media, update_attrs)
      assert manipulated_media.description == "some updated description"
      assert manipulated_media.url == "some updated url"
    end

    test "update_manipulated_media/2 with invalid data returns error changeset" do
      manipulated_media = manipulated_media_fixture()
      assert {:error, %Ecto.Changeset{}} = Canon.update_manipulated_media(manipulated_media, @invalid_attrs)
      assert manipulated_media == Canon.get_manipulated_media!(manipulated_media.id)
    end

    test "delete_manipulated_media/1 deletes the manipulated_media" do
      manipulated_media = manipulated_media_fixture()
      assert {:ok, %ManipulatedMedia{}} = Canon.delete_manipulated_media(manipulated_media)
      assert_raise Ecto.NoResultsError, fn -> Canon.get_manipulated_media!(manipulated_media.id) end
    end

    test "change_manipulated_media/1 returns a manipulated_media changeset" do
      manipulated_media = manipulated_media_fixture()
      assert %Ecto.Changeset{} = Canon.change_manipulated_media(manipulated_media)
    end
  end

  describe "factcheck_articles" do
    alias DAU.Canon.FactcheckArticle

    import DAU.CanonFixtures

    @invalid_attrs %{title: nil, author: nil, url: nil, publisher: nil, excerpt: nil}

    test "list_factcheck_articles/0 returns all factcheck_articles" do
      factcheck_article = factcheck_article_fixture()
      assert Canon.list_factcheck_articles() == [factcheck_article]
    end

    test "get_factcheck_article!/1 returns the factcheck_article with given id" do
      factcheck_article = factcheck_article_fixture()
      assert Canon.get_factcheck_article!(factcheck_article.id) == factcheck_article
    end

    test "create_factcheck_article/1 with valid data creates a factcheck_article" do
      valid_attrs = %{title: "some title", author: "some author", url: "some url", publisher: "some publisher", excerpt: "some excerpt"}

      assert {:ok, %FactcheckArticle{} = factcheck_article} = Canon.create_factcheck_article(valid_attrs)
      assert factcheck_article.title == "some title"
      assert factcheck_article.author == "some author"
      assert factcheck_article.url == "some url"
      assert factcheck_article.publisher == "some publisher"
      assert factcheck_article.excerpt == "some excerpt"
    end

    test "create_factcheck_article/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Canon.create_factcheck_article(@invalid_attrs)
    end

    test "update_factcheck_article/2 with valid data updates the factcheck_article" do
      factcheck_article = factcheck_article_fixture()
      update_attrs = %{title: "some updated title", author: "some updated author", url: "some updated url", publisher: "some updated publisher", excerpt: "some updated excerpt"}

      assert {:ok, %FactcheckArticle{} = factcheck_article} = Canon.update_factcheck_article(factcheck_article, update_attrs)
      assert factcheck_article.title == "some updated title"
      assert factcheck_article.author == "some updated author"
      assert factcheck_article.url == "some updated url"
      assert factcheck_article.publisher == "some updated publisher"
      assert factcheck_article.excerpt == "some updated excerpt"
    end

    test "update_factcheck_article/2 with invalid data returns error changeset" do
      factcheck_article = factcheck_article_fixture()
      assert {:error, %Ecto.Changeset{}} = Canon.update_factcheck_article(factcheck_article, @invalid_attrs)
      assert factcheck_article == Canon.get_factcheck_article!(factcheck_article.id)
    end

    test "delete_factcheck_article/1 deletes the factcheck_article" do
      factcheck_article = factcheck_article_fixture()
      assert {:ok, %FactcheckArticle{}} = Canon.delete_factcheck_article(factcheck_article)
      assert_raise Ecto.NoResultsError, fn -> Canon.get_factcheck_article!(factcheck_article.id) end
    end

    test "change_factcheck_article/1 returns a factcheck_article changeset" do
      factcheck_article = factcheck_article_fixture()
      assert %Ecto.Changeset{} = Canon.change_factcheck_article(factcheck_article)
    end
  end
end
