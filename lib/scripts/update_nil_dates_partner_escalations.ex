defmodule Scripts.UpdateNilDatesPartnerEscalations do
  alias DAU.OpenData.PartnerEscalation
  alias DAU.Repo

  @moduledoc """
  On initial seeding, some rows in the partner escalations table got seeded with NULL Dates. This script updates those rows.
  """

  def run() do
    updates = [
      %{uuid: "e4b7d77b-7bd7-4678-8e98-658511bab096", date: ~D[2025-04-15]},
      %{uuid: "f36261e6-16a5-462d-a9b2-e0b1db8cc54b", date: ~D[2025-04-14]},
      %{uuid: "c387322f-0b1e-4429-80d8-9f2ed9f42e46", date: ~D[2025-02-04]},
      %{uuid: "b6600eb7-3e25-4e2f-a698-ad60159d0f98", date: ~D[2025-02-04]},
      %{uuid: "86c58f12-7179-49be-99af-b89078d4e6b3", date: ~D[2024-11-29]},
      %{uuid: "9f12713b-d10d-434b-b773-e4f92639a28d", date: ~D[2024-11-25]},
      %{uuid: "618ccc72-266d-42f0-8f2e-029e1e3005e8", date: ~D[2024-10-16]},
      %{uuid: "6855487c-c009-4804-8047-72f5e4e206e3", date: ~D[2024-09-26]}
    ]

    Enum.each(updates, fn %{uuid: uuid, date: date} ->
      PartnerEscalation
      |> Repo.get_by!(uuid: uuid)
      |> PartnerEscalation.changeset(%{date: date})
      |> Repo.update!()
    end)

  end
end
