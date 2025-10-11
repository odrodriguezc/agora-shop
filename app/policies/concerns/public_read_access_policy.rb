
# This module defines a policy for public read access.
# It provides methods to determine whether certain actions are permitted
# based on the user's role or other conditions.
#
# Methods:
# - `show?`: Always returns `true`, allowing public read access.
# - `index?`: Alias for `show?`, allowing public access to index actions.
# - `create?`: Returns `true` if the user is an admin, restricting creation to admins.
# - `new?`: Alias for `create?`, restricting new actions to admins.
# - `edit?`: Alias for `create?`, restricting edit actions to admins.
# - `update?`: Alias for `create?`, restricting update actions to admins.
# - `destroy?`: Alias for `create?`, restricting destroy actions to admins.
#
# Note:
# The `admin?` method is expected to be defined elsewhere, determining
# whether the current user has admin privileges.
module PublicReadAccessPolicy
  def show?
    true
  end
  alias_method :index?, :show?

  def create?
    admin?
  end
  alias_method :new?, :create?
  alias_method :edit?, :create?
  alias_method :update?, :create?
  alias_method :destroy?, :create?
end
