defmodule Scripts.SeedEscalationData do
  def seed_data do
    data =
      File.read!("priv/external_escalations_seed_data/external_escalations_seed_data.json")
      |> Jason.decode!()

    # IO.inspect(data)
    Enum.each(data, fn item ->
      fixed_item = fix_item(item)
      result = DAU.ExternalEscalation.create_external_escalation(fixed_item)
      IO.inspect({:item, fixed_item, :result, result})
    end)
  end

  defp fix_item(item) do
    item
    |> Map.update("escalation_media_type", [], fn media_list_string ->
      media_list_string
      |> String.split(",")
      |> Enum.map(fn val ->
        case val do
          "Audio file" -> :audio
          "Video file" -> :video
          "Both" -> :both
        end
      end)
    end)
    |> Map.update("content_platform", nil, fn val ->
      val
      |> String.downcase()
      |> case do
        "Facebook" -> "facebook"
        "Instagram" -> "instagram"
        "Whatsapp" -> "whatsapp"
        "X" -> "x"
        "Other" -> "other"
        _ -> "other"
      end
    end)
  end
end
