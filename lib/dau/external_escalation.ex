defmodule DAU.ExternalEscalation do
  alias DAU.ExternalEscalation.FormEntry
  alias DAU.Repo

  def create_external_escalation(attrs) do
    %FormEntry{}
    |> FormEntry.changeset(attrs)
    |> Repo.insert()
  end
end
