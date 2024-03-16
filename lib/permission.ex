defmodule Permission do
  @moduledoc """
  Rudimentary role based access control for dashboard.

  This module helps answer the question - Can user U perform an action A on resource R.
  U is `DAU.Accounts.User` with U.role ∈ {:expert_factchecker, :expert_forensic, :secratariat_manager,
  :secratariat_associate, :admin}. Refer `DAU.Accounts.User` for definition.
  A ∈ {:create, :edit, :delete}
  R is any module that implements the Ecto.Schema behaviour

  ## Background Information
  Dashboard Users can have Roles - user(by default), expert_factchecker, expert_forensic, secratariat_manager,
  secratariat_associate, admin.  Roles have privileges which are defined in `priviledges/0`

  ## Examples
  user_a = Repo.get(User, 1)
  user_b = Repo.get(User, 2)
  user_admin = Repo.get(User, 3)

  Permission.has_privilege?(user_admin, :add, Common)
  true

  Permission.has_privilege?(user_a, :add, Common)
  false

  Permission.has_privilege?(user_a, :edit, Common)
  true
  """
  alias DAU.Accounts.User
  alias DAU.Feed.Common
  alias DAU.Canon.FactcheckArticle

  @doc """

  """
  def has_privilege?(%User{} = user, action, resource) do
    case user.role do
      :admin -> true
      _ -> MapSet.member?(privileges()[user.role], {action, resource})
    end
  end

  @doc """
  todo : macro to simplify specifying privileges
  """
  defp privileges() do
    %{
      secratariat_manager:
        MapSet.new()
        |> MapSet.put({:add, FactcheckArticle})
        |> MapSet.put({:edit, Common}),
      secratariat_associate:
        MapSet.new()
        |> MapSet.put({:add, FactcheckArticle})
        |> MapSet.put({:edit, Common}),
      expert_factchecker:
        MapSet.new()
        |> MapSet.put({:add, FactcheckArticle})
    }
  end
end
