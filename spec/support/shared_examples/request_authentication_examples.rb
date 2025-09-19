

# This shared example is used to test that a request requires authentication.
# It expects a `perform_request` callable to be defined in the test context,
# which performs the request being tested. The example verifies that the
# response redirects to the login page (`new_session_url`) when authentication
# is required.
RSpec.shared_examples "requires authentication" do
  it "redirects to the login page" do
    perform_request.call

    expect(response).to redirect_to(new_session_url)
  end
end
