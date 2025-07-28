defmodule Scripts.SeedEscalationData do

  def seed_data(file_path \\"priv/external_escalations_seed_data/dau_latest_escalation_entries.json") do
    File.read!(file_path)
    |> Jason.decode!()
    |> Enum.each(&insert_item/1)
  end

  defp insert_item(item) do
    ts = parse_timestamp(item["Timestamp"])

    attrs =
      item
      |> fix_item()
      |> atomize_keys()
      |> Map.merge(%{inserted_at: ts, updated_at: ts})

    result = DAU.ExternalEscalation.create_external_escalation(attrs)
    IO.inspect({:item, attrs, :result, result})
    :timer.sleep(500)
  end

  defp fix_item(item) do
    item
    |> Map.update("escalation_media_type", [], fn media_list_string ->
      String.split(media_list_string, ",")
      |> Enum.map(&cast_media/1)
    end)
    |> Map.update("content_platform", nil, &cast_platform/1)
  end

  defp cast_media("Audio file"), do: :audio
  defp cast_media("Video file"), do: :video
  defp cast_media("Both"),       do: :both

  defp cast_platform(val) do
    val
    |> String.downcase()
    |> case do
      "facebook"  -> "facebook"
      "instagram" -> "instagram"
      "whatsapp"  -> "whatsapp"
      "x"         -> "x"
      _           -> "other"
    end
  end

  defp atomize_keys(map) do
    for {k, v} <- map, into: %{}, do: {String.to_atom(k), v}
  end

  # parse e.g. "2024/08/29 6:43:24 pm GMT+5:30" into a UTC-naive datetime
  defp parse_timestamp(ts_string) do
    # ["2024/08/29 6:43:24 pm", "+5:30"]
    [dt_part, offset_part] = String.split(ts_string, " GMT")

    # parse the naive date/time
    {:ok, naive_dt} =
      Timex.parse(dt_part, "{YYYY}/{0M}/{0D} {h12}:{m}:{s} {AM}")

    # turn "+5:30" into total minutes
    total_minutes =
      offset_part
      |> String.trim_leading("+")
      |> String.split(":")
      |> then(fn [h, m] ->
        String.to_integer(h) * 60 + String.to_integer(m)
      end)

    # if it was a negative offset, flip sign
    total_minutes = if String.starts_with?(offset_part, "-"), do: -total_minutes, else: total_minutes

    # subtract the offset to get UTC
    utc_naive = Timex.shift(naive_dt, minutes: -total_minutes)

    # now tag it as a UTC DateTime and drop the zone
    utc_naive
    |> Timex.to_datetime("Etc/UTC")
    |> DateTime.to_naive()
  end



end
