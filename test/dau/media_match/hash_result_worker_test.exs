defmodule DAU.MediaMatch.HashResultWorkerTest do
  use DAU.DataCase
  use Oban.Testing, repo: DAU.Repo

  alias DAU.Blake2BFixtures
  alias DAU.MediaMatch.Hash
  alias DAU.MediaMatch.HashResultWorker
  alias DAU.UserMessage.Conversation
  alias DAU.UserMessageFixtures

  setup do
    {:ok, message} =
      UserMessageFixtures.inbox_message_attrs(:video, %{"user_language_input" => "hi"})
      |> Conversation.add_to_inbox()
      |> elem(1)
      |> Conversation.add_message_properties()

    %{message: message}
  end

  test "saves the hash with its worker version and counts it", %{message: message} do
    args = Blake2BFixtures.make_response_args(:video, message.id)

    assert :ok = perform_job(HashResultWorker, args)

    hash = Repo.get_by!(Hash, inbox_id: message.id)
    assert hash.worker_version == "blake2b"

    {:ok, conversation} = Conversation.build(message.id)
    assert Conversation.get_media_count(conversation) == 1
  end

  test "accepts a feluda video result body", %{message: message} do
    args = %{
      "inbox_id" => message.id,
      "hash_value" => "AACAPwAAAEAAAEBA",
      "media_type" => "video",
      "worker_version" => "feluda-video-hash@0.1.1"
    }

    assert :ok = perform_job(HashResultWorker, args)
    assert Repo.get_by!(Hash, inbox_id: message.id).worker_version == "feluda-video-hash@0.1.1"
  end

  test "running the same result twice changes nothing the second time", %{message: message} do
    args = Blake2BFixtures.make_response_args(:video, message.id)

    assert :ok = perform_job(HashResultWorker, args)
    assert :ok = perform_job(HashResultWorker, args)

    assert Repo.aggregate(from(h in Hash, where: h.inbox_id == ^message.id), :count) == 1
    {:ok, conversation} = Conversation.build(message.id)
    assert Conversation.get_media_count(conversation) == 1
  end

  test "cancels when the inbox does not exist" do
    args = Blake2BFixtures.make_response_args(:video, -1)

    assert {:cancel, :inbox_not_found} = perform_job(HashResultWorker, args)
  end

  test "cancels when args are invalid", %{message: message} do
    args = Blake2BFixtures.make_response_args(:video, message.id) |> Map.delete("hash_value")

    assert {:cancel, :invalid_args} = perform_job(HashResultWorker, args)
  end
end
