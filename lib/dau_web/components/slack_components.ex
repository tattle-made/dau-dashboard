defmodule DAUWeb.Components.SlackComponents do
  use Phoenix.Component
  import Phoenix.HTML
  import Phoenix.HTML.Link

  attr :message, :map, required: true
  attr :show_thread_indicator, :boolean, default: false
  attr :on_thread_toggle, :any, default: nil

  def message(assigns) do
    ~H"""
    <div class={["message mb-4 p-4 border rounded-lg", @message.is_deleted && "bg-gray-100"]}>
      <div class="flex items-start gap-3">
        <div class="flex-shrink-0 w-10 h-10 rounded-full bg-gray-300 flex items-center justify-center">
          <%= String.first(@message.user || "?") %>
        </div>
        <div class="flex-1">
          <div class="flex items-center gap-2 text-sm text-gray-500 mb-1">
            <span class="font-medium"><%= @message.user %></span>
            <span class="text-xs">
              <%= @message.ts_utc
              |> Timex.Timezone.convert("Asia/Kolkata")
              |> Timex.format!("{Mshort} {D}, {h12}:{m} {AM} IST") %>
              <%= if @message.is_edited, do: "(edited)" %>
            </span>
          </div>

          <div class="message-content">
            <%= if @message.text do %>
              <p class="whitespace-pre-wrap"><%= @message.text %></p>
            <% end %>

            <.files files={@message.files} />

            <%= if @show_thread_indicator && length(@message.thread_messages || []) > 0 do %>
              <div class="thread-replies mt-3">
                <button
                  phx-click={@on_thread_toggle}
                  class="flex items-center text-xs text-gray-500 hover:text-gray-700 mb-2 focus:outline-none"
                >
                  <svg
                    class="w-3 h-3 mr-1 transition-transform duration-200"
                    id={"thread-icon-#{@message.id}"}
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M19 9l-7 7-7-7"
                    />
                  </svg>
                  <%= length(@message.thread_messages) %> <%= if length(@message.thread_messages) ==
                                                                   1,
                                                                 do: "reply",
                                                                 else: "replies" %>
                </button>
                <div id={"thread-#{@message.id}"} class="pl-4 border-l-2 border-gray-200 hidden">
                  <!--
                    <div class="text-xs text-gray-500 mb-2">
                      <%= length(@message.thread_messages) %> <%= if length(@message.thread_messages) ==
                                                                       1,
                                                                     do: "reply",
                                                                     else: "replies" %>
                    </div>
                  -->
                  <%= for reply <- @message.thread_messages do %>
                    <div class="reply mb-3 p-2 bg-gray-50 rounded">
                      <div class="flex items-center gap-2 text-xs text-gray-500 mb-1">
                        <span class="font-medium"><%= reply.user %></span>
                        <span>
                          <%= reply.ts_utc
                          |> Timex.Timezone.convert("Asia/Kolkata")
                          |> Timex.format!("{Mshort} {D}, {h12}:{m} {AM} IST") %>
                          <%= if reply.is_edited, do: "(edited)" %>
                        </span>
                      </div>
                      <p class="text-sm mb-2"><%= reply.text %></p>
                      <.files files={reply.files} />
                    </div>
                  <% end %>
                </div>
              </div>
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :files, :list, default: []

  def files(assigns) do
    ~H"""
    <%= if length(@files) > 0 do %>
      <div class="files grid grid-cols-1 md:grid-cols-2 gap-2 my-2">
        <%= for file <- @files do %>
          <div class="file-item border rounded p-2 flex items-center gap-2">
            <div class="file-icon text-blue-500 flex-shrink-0">
              <%= cond do %>
                <% String.starts_with?(file.mimetype, "image/") -> %>
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"
                    />
                  </svg>
                <% String.starts_with?(file.mimetype, "video/") -> %>
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"
                    />
                  </svg>
                <% true -> %>
                  <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                    />
                  </svg>
              <% end %>
            </div>
            <div class="flex flex-wrap gap-2 items-center w-full">
              <a
                href={file.url_private}
                target="_blank"
                class="text-sm text-blue-600 hover:underline break-all"
                title={file.title}
              >
                <%= file.title || "File" %>
              </a>
              <span class="text-xs text-gray-500 whitespace-nowrap">
                <%= String.upcase(file.filetype) %>
              </span>
              <a
                href={file.permalink || file.url_private_download}
                target="_blank"
                class="ml-auto text-gray-500 hover:text-gray-700"
                title="View in Slack"
              >
                <!--
                  # <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 24 24">
                  #   <path d="M9 12h6m-3-3v6m-9 1V8a2 2 0 012-2h12a2 2 0 012 2v8a2 2 0 01-2 2H5a2 2 0 01-2-2z" />
                  # </svg>
                -->
                <svg class="w-4 h-4 text-current" viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg">
                  <path d="M9.0423,19.1661A2.5212,2.5212,0,1,1,6.5212,16.645H9.0423Z" fill="currentColor" />
                  <path d="M10.3127,19.1661a2.5212,2.5212,0,0,1,5.0423,0v6.3127a2.5212,2.5212,0,1,1-5.0423,0Z" fill="currentColor" />
                  <path d="M12.8339,9.0423A2.5212,2.5212,0,1,1,15.355,6.5212V9.0423Z" fill="currentColor" />
                  <path d="M12.8339,10.3127a2.5212,2.5212,0,0,1,0,5.0423H6.5212a2.5212,2.5212,0,1,1,0-5.0423Z" fill="currentColor" />
                  <path d="M22.9577,12.8339a2.5212,2.5212,0,1,1,2.5211,2.5211H22.9577Z" fill="currentColor" />
                  <path d="M21.6873,12.8339a2.5212,2.5212,0,0,1-5.0423,0V6.5212a2.5212,2.5212,0,1,1,5.0423,0Z" fill="currentColor" />
                  <path d="M19.1661,22.9577a2.5212,2.5212,0,1,1-2.5211,2.5211V22.9577Z" fill="currentColor" />
                  <path d="M19.1661,21.6873a2.5212,2.5212,0,0,1,0-5.0423h6.3127a2.5212,2.5212,0,1,1,0,5.0423Z" fill="currentColor" />
                </svg>
              </a>
              <a
                href={file.url_private_download}
                download
                class="text-gray-500 hover:text-gray-700"
                title="Download"
              >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"
                  />
                </svg>
              </a>
            </div>
          </div>
        <% end %>
      </div>
    <% end %>
    """
  end
end
