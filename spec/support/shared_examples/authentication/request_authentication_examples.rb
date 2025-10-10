
# This shared example is used to test that a request requires authentication.
# It verifies that the response redirects to the login page when the request
# is performed without proper authentication.
#
# Usage:
#   Include this shared example in your request specs to ensure that
#   unauthenticated requests are properly handled.
#
# Example:
#   RSpec.describe SomeController, type: :request do
#     it_behaves_like "requires authentication" do
#       let(:perform_request) { -> { get some_protected_path } }
#     end
#   end
#
# Note:
#   - The `perform_request` variable must be defined in the context where
#     this shared example is used. It should be a callable (e.g., a lambda)
#     that performs the request being tested.
RSpec.shared_examples "requires authentication" do
  it "redirects to the login page" do
    perform_request.call

    expect(response).to redirect_to(new_session_url)
  end
end
