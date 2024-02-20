defmodule DAU.VerificationTest do
  use DAU.DataCase

  alias DAU.Verification

  describe "queries" do
    alias DAU.Verification.Query

    import DAU.VerificationFixtures

    @invalid_attrs %{messages: nil, status: nil}

    test "list_queries/0 returns all queries" do
      query = query_fixture()
      assert Verification.list_queries() == [query]
    end

    test "get_query!/1 returns the query with given id" do
      query = query_fixture()
      assert Verification.get_query!(query.id) == query
    end

    test "create_query/1 with valid data creates a query" do
      valid_attrs = %{messages: ["option1", "option2"], status: "some status"}

      assert {:ok, %Query{} = query} = Verification.create_query(valid_attrs)
      assert query.messages == ["option1", "option2"]
      assert query.status == "some status"
    end

    test "create_query/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Verification.create_query(@invalid_attrs)
    end

    test "update_query/2 with valid data updates the query" do
      query = query_fixture()
      update_attrs = %{messages: ["option1"], status: "some updated status"}

      assert {:ok, %Query{} = query} = Verification.update_query(query, update_attrs)
      assert query.messages == ["option1"]
      assert query.status == "some updated status"
    end

    test "update_query/2 with invalid data returns error changeset" do
      query = query_fixture()
      assert {:error, %Ecto.Changeset{}} = Verification.update_query(query, @invalid_attrs)
      assert query == Verification.get_query!(query.id)
    end

    test "delete_query/1 deletes the query" do
      query = query_fixture()
      assert {:ok, %Query{}} = Verification.delete_query(query)
      assert_raise Ecto.NoResultsError, fn -> Verification.get_query!(query.id) end
    end

    test "change_query/1 returns a query changeset" do
      query = query_fixture()
      assert %Ecto.Changeset{} = Verification.change_query(query)
    end
  end

  describe "comments" do
    alias DAU.Verification.Comment

    import DAU.VerificationFixtures

    @invalid_attrs %{content: nil}

    test "list_comments/0 returns all comments" do
      comment = comment_fixture()
      assert Verification.list_comments() == [comment]
    end

    test "get_comment!/1 returns the comment with given id" do
      comment = comment_fixture()
      assert Verification.get_comment!(comment.id) == comment
    end

    test "create_comment/1 with valid data creates a comment" do
      valid_attrs = %{content: %{}}

      assert {:ok, %Comment{} = comment} = Verification.create_comment(valid_attrs)
      assert comment.content == %{}
    end

    test "create_comment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Verification.create_comment(@invalid_attrs)
    end

    test "update_comment/2 with valid data updates the comment" do
      comment = comment_fixture()
      update_attrs = %{content: %{}}

      assert {:ok, %Comment{} = comment} = Verification.update_comment(comment, update_attrs)
      assert comment.content == %{}
    end

    test "update_comment/2 with invalid data returns error changeset" do
      comment = comment_fixture()
      assert {:error, %Ecto.Changeset{}} = Verification.update_comment(comment, @invalid_attrs)
      assert comment == Verification.get_comment!(comment.id)
    end

    test "delete_comment/1 deletes the comment" do
      comment = comment_fixture()
      assert {:ok, %Comment{}} = Verification.delete_comment(comment)
      assert_raise Ecto.NoResultsError, fn -> Verification.get_comment!(comment.id) end
    end

    test "change_comment/1 returns a comment changeset" do
      comment = comment_fixture()
      assert %Ecto.Changeset{} = Verification.change_comment(comment)
    end
  end

  describe "response" do
    alias DAU.Verification.Response

    import DAU.VerificationFixtures

    @invalid_attrs %{content: nil}

    test "list_response/0 returns all response" do
      response = response_fixture()
      assert Verification.list_response() == [response]
    end

    test "get_response!/1 returns the response with given id" do
      response = response_fixture()
      assert Verification.get_response!(response.id) == response
    end

    test "create_response/1 with valid data creates a response" do
      valid_attrs = %{content: %{}}

      assert {:ok, %Response{} = response} = Verification.create_response(valid_attrs)
      assert response.content == %{}
    end

    test "create_response/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Verification.create_response(@invalid_attrs)
    end

    test "update_response/2 with valid data updates the response" do
      response = response_fixture()
      update_attrs = %{content: %{}}

      assert {:ok, %Response{} = response} = Verification.update_response(response, update_attrs)
      assert response.content == %{}
    end

    test "update_response/2 with invalid data returns error changeset" do
      response = response_fixture()
      assert {:error, %Ecto.Changeset{}} = Verification.update_response(response, @invalid_attrs)
      assert response == Verification.get_response!(response.id)
    end

    test "delete_response/1 deletes the response" do
      response = response_fixture()
      assert {:ok, %Response{}} = Verification.delete_response(response)
      assert_raise Ecto.NoResultsError, fn -> Verification.get_response!(response.id) end
    end

    test "change_response/1 returns a response changeset" do
      response = response_fixture()
      assert %Ecto.Changeset{} = Verification.change_response(response)
    end
  end
end
