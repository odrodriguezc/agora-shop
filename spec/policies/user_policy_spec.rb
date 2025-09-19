# This is a test suite for the UserPolicy class, which is responsible for
# defining access control rules for User records in the application.
#
# The test suite uses RSpec and shared examples to ensure that the policy
# enforces the correct permissions for different types of users:
#
# - Owner: The user who owns the record.
# - Non-owner: A user who does not own the record.
# - Admin: A user with administrative privileges.
#
# Shared examples are used to test the following scenarios:
#
# 1. "a policy enforcing owner-based access":
#    - Allows the owner to perform actions such as `show`, `profile`, `update`,
#      `edit`, and `destroy`.
#    - Forbids the owner from performing actions such as `index`, `new`, and
#      `create`.
#
# 2. "a policy permitting a role admin to access":
#    - Allows an admin user to perform all actions, including `show`, `profile`,
#      `update`, `edit`, `destroy`, `index`, `new`, and `create`.
#
# The test suite ensures that the UserPolicy class adheres to the expected
# behavior for access control based on user roles and ownership.
require 'rails_helper'
#
RSpec.describe UserPolicy, type: :policy do
  subject { described_class.new(user, record) }
  let(:record) { create_guest_user } # The user record being accessed
  let(:owner) { record }
  let(:non_owner) { create_guest_user }
  let(:admin_user) { create_admin_user }

  it_behaves_like "a policy enforcing owner-based access",
                  allow: %i[show profile update edit destroy],
                  forbid: %i[index new create]

  it_behaves_like "a policy permitting a role admin to access",
                  allow: %i[show profile update edit destroy index new create]
end
