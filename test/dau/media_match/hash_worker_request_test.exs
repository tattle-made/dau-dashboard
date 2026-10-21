defmodule DAU.MediaMatch.HashWorkerRequestTest do
  use DAU.DataCase

  alias DAU.MediaMatch.HashWorkerRequest
  alias DAU.UserMessage
  alias DAU.UserMessageFixtures

  doctest HashWorkerRequest

  test "builds from an inbox using its file_key, not its path" do
    inbox = UserMessageFixtures.inbox_video_message_fixture()
    inbox = UserMessage.get_incoming_message!(inbox.id)

    assert {:ok, %HashWorkerRequest{} = request} = HashWorkerRequest.new(inbox)
    assert request.inbox_id == inbox.id
    assert request.file_key == "temp/video-01.mp4"
    assert request.media_type == :video
  end

  test "rejects an inbox without a file_key" do
    inbox = UserMessageFixtures.inbox_video_message_fixture()

    assert {:error, "Hash worker request is badly formed"} = HashWorkerRequest.new(inbox)
  end
end
