defmodule Permission.RouteAuthorization do
  @moduledoc """
  Route-level authorization rules based on user roles.

  This is intentionally scoped to route access and should remain
  simple and declarative.
  """

  alias DAU.Accounts.User

  @type permission :: :allow_driveby_user | :deny_driveby_user

  @spec allowed?(%User{} | nil, permission()) :: boolean()
  def allowed?(nil, _permission), do: false

  def allowed?(%User{role: :drive_by}, :allow_driveby_user), do: true
  def allowed?(%User{role: :drive_by}, :deny_driveby_user), do: false

  def allowed?(%User{}, _permission), do: true
end
