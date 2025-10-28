defmodule DAUWeb.SlackArchivesHomeLive do
  use DAUWeb, :live_view
  alias DAU.Slack
  import DAUWeb.Components.SlackComponents

  def mount(_params, _session, socket) do
    channels = Slack.get_all_channels()
    # IO.inspect(channels, label: "CHANNELS: ")

    {:ok, assign(socket, channels: channels)}
  end

  def handle_params(unsigned_params, uri, socket) do
    channel_id = get_in(unsigned_params, ["channel"])

    channel =
      case channel_id do
        nil -> nil
        channel_id -> Slack.get_slack_channel_from_channel_id(channel_id)
      end

    channel_messages =
      get_channel_messages(channel) |> Enum.filter(fn c -> is_nil(Map.get(c, :parent_id)) end)

    socket = assign(socket, current_channel: channel, channel_messages: channel_messages)

    {:noreply, socket}
  end

  defp get_channel_messages(channel) when is_nil(channel) do
    []
  end

  defp get_channel_messages(channel) do
    Slack.get_all_channel_messages(channel.id)
  end

  def handle_event("select-channel", params, socket) do
    # IO.inspect(params, label: "SELECT CHANNEL: ")
    socket = socket |> redirect(to: "/slack-archives?channel=#{params["channel_id"]}")
    {:noreply, socket}
  end

  # def render(assigns) do
  #   ~H"""
  #   <div class="flex h-[80vh]">
  #     <!-- Left Sidebar -->
  #     <div class="w-1/4 h-full border-r overflow-hidden">
  #       <div class="p-4 border-b">
  #         <h2>Channels List</h2>
  #       </div>
  #       <div class="h-full overflow-auto">
  #         <div class="p-4 border-b">Chat 1</div>
  #         <div class="p-4 border-b">Chat 2</div>
  #         <div class="p-4 border-b">Chat 3</div>
  #         <div class="p-4 border-b">Chat 3</div>
  #         <div class="p-4 border-b">Chat 3</div>
  #         <div class="p-4 border-b">Chat 3</div>
  #         <div class="p-4 border-b">Chat 3</div>
  #         <div class="p-4 border-b">Chat 3</div>
  #         <div class="p-4 border-b">Chat 3</div>
  #         <div class="p-4 border-b">Chat 3</div>
  #       </div>
  #     </div>

  #     <!-- Main Content -->
  #     <div class="flex-1 flex flex-col overflow-hidden">
  #       <div class="p-4 border-b">
  #         <h2>Chat Title</h2>
  #       </div>
  #       <div class="flex-1 p-4 overflow-auto">
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #         <p>Messages will appear here</p>
  #       </div>

  #     </div>
  #   </div>
  #   """
  # end
end
