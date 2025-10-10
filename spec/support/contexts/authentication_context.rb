
# This file defines shared contexts for RSpec request specs to simulate
# authenticated and unauthenticated user scenarios.

# Shared Context: "as authenticated user"
# - Sets up a `current_user` using the `create_user` helper method.
# - Eager loads an `other_user` to ensure user count tests are not affected.
# - Signs in the `current_user` before each example.
#
# Usage:
#   Include this shared context in your request specs to simulate
#   an authenticated user making requests.

# Shared Context: "as unauthenticated user"
# - Eager loads an `other_user` to ensure user count tests are not affected.
# - Signs out any user before each example.
#
# Usage:
#   Include this shared context in your request specs to simulate
#   an unauthenticated user making requests.
RSpec.shared_context "as authenticated user", type: :request do
  let(:current_user) { create_user }
  let!(:other_user) { create_user } # Eager load to do not affect the user count tests

  before { sign_in_as(current_user) }
end

RSpec.shared_context "as unauthenticated user", type: :request do
  let!(:other_user) { create_user } # Eager load to do not affect the user count tests
  before { sign_out }
end
