defmodule DAUWeb.UserMessagePreferenceJson do
  alias DAU.UserMessage.Preference

  def show(%{preference: preference}) do
    %{data: data(preference)}
  end

  defp data(%Preference{} = preference) do
    %{
      sender_number: preference.sender_number,
      language: preference.language
    }
  end
end
