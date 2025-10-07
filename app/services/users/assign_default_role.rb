# This service object is responsible for assigning a default role to a user
# if the user does not already have any roles assigned.
#
# Usage:
#   Users::AssignDefaultRole.new(user).call
#
# Dependencies:
#   - Assumes the `user` object responds to `roles` and `add_role` methods.
#   - Relies on the presence of a `User::DEFAULT_ROLE` constant.
#
# Methods:
#   - call: Checks if the user has no roles and assigns the default role.
module Users
  class AssignDefaultRole < Users::Base
    def call
      return unless user.roles.blank?

      user.add_role(User::DEFAULT_ROLE)
    end
  end
end
