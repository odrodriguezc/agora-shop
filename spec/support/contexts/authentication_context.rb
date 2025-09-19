# Defines helper methods for signing in and out users in request specs.
# Usage:
#   include_context "authentication context"
#   sign_in_as(user)
#   sign_out
#   This sets the Current.session and manages cookies for authentication.
# Inspired by module SessionTestHelper recently merged
# https://github.com/rails/rails/issues/53207
RSpec.shared_context "authentication context", type: :request do
  def sign_in_as(user)
    Current.session = user.sessions.create!

    ActionDispatch::TestRequest.create.cookie_jar.tap do |cookie_jar|
      cookie_jar.signed[:session_id] = Current.session.id
      cookies[:session_id] = cookie_jar[:session_id]
    end
  end

  def sign_out
    Current.session&.destroy!
    cookies.delete(:session_id)
  end
end

RSpec.shared_context "as authenticated user", type: :request do
  let(:current_user) { create_user }
  let!(:other_user) { create_user } # Eager load to do not affect the user count tests

  before { sign_in_as(current_user) }
end

RSpec.shared_context "as admin user", type: :request do
  let(:current_user) { create_admin_user }
  let!(:other_user) { create_user } # Eager load to do not affect the user count tests

  before { sign_in_as(current_user) }
end

RSpec.shared_context "as unauthenticated user", type: :request do
  let!(:other_user) { create_user } # Eager load to do not affect the user count tests
  before { sign_out }
end
