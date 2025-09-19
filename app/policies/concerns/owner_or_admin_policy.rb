
# This module defines a policy for authorizing actions based on whether the user is
# the owner of a resource or has an admin role. It provides methods to check permissions
# for various actions such as index, show, update, edit, destroy, create, and new.
#
# Methods:
# - index?: Checks if the user is the owner or an admin.
# - show?: Checks if the user is the owner or an admin.
# - update?: Alias for show?.
# - edit?: Alias for show?.
# - destroy?: Alias for show?.
# - create?: Checks if the user is an admin or if no user is present.
# - new?: Alias for create?.
#
# Private Methods:
# - admin?: Checks if the user has the admin role.
# - owner_or_admin?: Checks if the user is either the owner or an admin.
# - owner?: Abstract method that must be implemented in the including class to define
#           ownership logic. Raises NotImplementedError if not implemented.
#
# Usage:
# Include this module in a policy class and implement the `owner?` method to define
# ownership logic specific to the resource being authorized.
module OwnerOrAdminPolicy
  def index?
    owner_or_admin?
  end

  def show?
    owner_or_admin?
  end

  alias_method :update?, :show?
  alias_method :edit?, :show?
  alias_method :destroy?, :show?

  def create?
    admin? || user.nil?
  end

  alias_method :new?, :create?

  private

  def admin?
    user&.has_role?(:admin)
  end

  def owner_or_admin?
    owner? || admin?
  end

  def owner?
    raise NotImplementedError, "#{self.class} class must implement owner?"
  end
end
