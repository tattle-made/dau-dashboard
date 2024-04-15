defmodule Permission do
  @moduledoc """
  Rudimentary role based access control for dashboard.

  This module helps answer the question - Can user U perform an action A on resource R.
  U is `DAU.Accounts.User` with U.role ∈ {:expert_factchecker, :expert_forensic, :secratariat_manager,
  :secratariat_associate, :admin}. Refer `DAU.Accounts.User` for definition.
  A ∈ {:view, :create, :edit, :delete}
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

  ## Future Features
  The current implementation lacks a notion of ownership. For eg allowing :edit action to be perfomed
  by the User who created or 'owns' a Resource.
  This can possibly be done by passing an opts Keyword List to has_privilege? - ownership: true
  We will have to standardize conventions for how ownership is implemented in the database to make
  the code simple.
  """
  # todo : is it possible to import all schema's somehow?
  alias DAU.UserMessage.Outbox
  alias DAU.Feed.FactcheckArticle
  alias DAU.Accounts.User
  alias DAU.Feed.Common

  def has_privilege?(%User{} = user, action, resource) do
    case user.role do
      :admin -> true
      _ -> MapSet.member?(privileges()[user.role], {action, resource})
    end
  end

  # todo : macro to simplify specifying privileges
  defp privileges() do
    %{
      secratariat_manager:
        MapSet.new()
        |> MapSet.put({:add, FactcheckArticle})
        |> MapSet.put({:approve, FactcheckArticle})
        |> MapSet.put({:edit, Common})
        |> MapSet.put({:view, Outbox}),
      secratariat_associate:
        MapSet.new()
        |> MapSet.put({:add, FactcheckArticle})
        |> MapSet.put({:approve, FactcheckArticle})
        |> MapSet.put({:edit, Common})
        |> MapSet.put({:view, Outbox}),
      expert_factchecker:
        MapSet.new()
        |> MapSet.put({:add, FactcheckArticle}),
      expert_forensic: MapSet.new(),
      user: MapSet.new()
    }
  end
end

defmodule PermissionException do
  defexception message: "You don't have the permission to do this operation"
end
