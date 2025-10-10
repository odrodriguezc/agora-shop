
# This file defines shared contexts for RSpec tests to simulate different user roles.
#
# Shared Contexts:
#
# - "as admin user":
#   Sets up the test environment to simulate an admin user.
#   - `current_user`: A user object with admin privileges, created using `create_admin_user`.
#   - `other_user`: Another user object, eagerly loaded to avoid affecting user count tests.
#   - Before each example, the `current_user` is signed in using `sign_in_as`.
#
# - "as guest user":
#   Sets up the test environment to simulate a guest user.
#   - `current_user`: A user object with guest privileges, created using `create_guest_user`.
#   - Before each example, the `current_user` is signed in using `sign_in_as`.
#
# Usage:
# Include these shared contexts in your RSpec tests to test behavior under different user roles.
RSpec.shared_context "as admin user", type: :request do
  let(:current_user) { create_admin_user }
  let!(:other_user) { create_user } # Eager load to do not affect the user count tests

  before { sign_in_as(current_user) }
end

RSpec.shared_context "as guest user", type: :request do
  let(:current_user) { create_guest_user }

  before { sign_in_as(current_user) }
end
