# Authentication helpers for request specs
# # Defines helper methods for signing in and out users in request specs.
# Usage:
#   include_context "authentication context"
#   sign_in_as(user)
#   sign_out
#   This sets the Current.session and manages cookies for authentication.
# Inspired by module SessionTestHelper recently merged
# https://github.com/rails/rails/issues/53207
module AuthenticationHelpers
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
