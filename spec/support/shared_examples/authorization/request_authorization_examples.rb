
# This file contains shared examples for testing authorization behavior in RSpec.
#
# Shared Examples:
#
# 1. "denies access with authorization alert":
#    - Purpose: Verifies that a request is denied access, the user is redirected to the `root_url`,
#      and an authorization alert is displayed in the flash message.
#    - Usage: Include this shared example in your test and define a `perform_request` lambda
#      in the test context. The lambda should execute the request being tested.
#    - Expectations:
#      - The response is redirected to the `root_url`.
#      - The flash alert contains the message: "You are not authorized to perform this action."
#
# 2. "denies access with JSON response":
#    - Purpose: Verifies that a request is denied access and an authorization error is returned
#      as a JSON response with a `403 Forbidden` status.
#    - Usage: Include this shared example in your test and define a `perform_request` lambda
#      in the test context. The lambda should execute the request being tested.
#    - Expectations:
#      - The response has a `403 Forbidden` status.
#      - The JSON response body contains:
#        {
#          "error" => "not_authorized",
#          "message" => "You are not authorized to perform this action."
#        }
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


RSpec.shared_examples "denies access with JSON response" do
  let(:default_json_alert) do
    {
      "error" => "not_authorized",
      "message" => "You are not authorized to perform this action."
    }
  end

  it "returns an authorization error as JSON" do
    perform_request.call

    expect(response).to have_http_status(:forbidden)
    expect(response.parsed_body).to eq(default_json_alert)
  end
end
