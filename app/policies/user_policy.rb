# This class defines the authorization policies for the User model.
# It inherits from ApplicationPolicy and includes the OwnerOrAdminPolicy module
# to provide shared methods for determining ownership or admin privileges.
#
# Methods:
# - profile?: Determines if the user has permission to view their profile.
#             Returns true if the user is the owner or an admin.
# - index?:   Determines if the user has permission to view the list of users.
#             Returns true if the user is an admin.
#
# Private Methods:
# - owner?:   Checks if the record is a User instance and if the current user
#             is the owner of the record.
class UserPolicy < ApplicationPolicy
  include OwnerOrAdminPolicy
  def profile?
    owner_or_admin?
  end

  def index?
    admin?
  end

  private

  def owner?
    record.is_a?(User) && record == user # Double check to be sure it's a user
  end
end
