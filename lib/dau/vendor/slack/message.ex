defmodule DAU.Vendor.Slack.Message do
  def send(:dau_alerts, event_type, message, params) do
    slack_webhook_url = Application.get_env(:dau, :slack_webhook_url)

    headers = [
      {"Content-Type", "application/json"}
    ]

    {:ok, slack_message} = Jason.encode(%{type: event_type, payload: params})

    body = %{
      "blocks" => [
        %{
          "type" => "section",
          "text" => %{
            "type" => "mrkdwn",
            "text" => "# #{message}"
          }
        },
        %{
          "type" => "section",
          "text" => %{
            "type" => "mrkdwn",
            "text" => "```#{slack_message}```"
          }
        }
      ]
    }

    {:ok, body_json} = Jason.encode(body)

    HTTPoison.post(slack_webhook_url, body_json, headers)
  end
end
