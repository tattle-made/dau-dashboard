defmodule DAU.MediaMatch.CreateJobTest do
  use DAU.DataCase
  use Oban.Testing, repo: DAU.Repo

  alias DAU.MediaMatch
  alias DAU.UserMessage
  alias DAU.UserMessageFixtures

  setup do
    inbox = UserMessageFixtures.inbox_video_message_fixture()
    %{inbox: UserMessage.get_incoming_message!(inbox.id)}
  end

  test "enqueues a hash request job for the worker", %{inbox: inbox} do
    assert {:ok, _job} = MediaMatch.create_job(inbox, :hash_worker)

    assert_enqueued(
      queue: "media_hash",
      worker: "dau_worker.hash_worker.HashWorker",
      args: %{inbox_id: inbox.id, file_key: "temp/video-01.mp4", media_type: "video"}
    )
  end

  test "enqueueing twice for one inbox creates one job", %{inbox: inbox} do
    assert {:ok, _first} = MediaMatch.create_job(inbox, :hash_worker)
    assert {:ok, second} = MediaMatch.create_job(inbox, :hash_worker)

    assert second.conflict?
    assert [_job] = all_enqueued(queue: "media_hash")
  end

  test "returns an error for an invalid request" do
    inbox = UserMessageFixtures.inbox_video_message_fixture()

    assert {:error, "Hash worker request is badly formed"} =
             MediaMatch.create_job(inbox, :hash_worker)

    refute_enqueued(queue: "media_hash")
  end
end
