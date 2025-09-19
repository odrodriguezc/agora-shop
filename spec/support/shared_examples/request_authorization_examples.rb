
# This shared example is used to test that a request is denied access
# and the user is redirected with an authorization alert.
#
# Example usage:
#   include_examples "denies access with authorization alert" do
#     let(:perform_request) { -> { get some_protected_path } }
#   end
#
# Required setup:
# - Define a `perform_request` lambda in the context where this shared example is included.
#   The lambda should execute the request being tested.
#
# Expectations:
# - The response is redirected to the `root_url`.
# - The flash alert contains the message: "You are not authorized to perform this action."
RSpec.shared_examples "denies access with authorization alert" do
  let(:expected_redirect) { root_url }

  it "redirects with an authorization alert" do
    perform_request.call

    expect(response).to redirect_to(expected_redirect)
    expect(flash[:alert]).to eq("You are not authorized to perform this action.")
  end
end
