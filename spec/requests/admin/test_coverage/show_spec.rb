# spec/requests/admin/test_coverage/show_spec.rb
#
# Purpose:
#   Request spec for Admin::TestCoverageController#show. Verifies that the
#   show action is accessible and returns a successful HTTP response when
#   accessed by an admin user.
#
# Scope:
#   - Exercise the controller via an HTTP request (full-stack request spec).
#   - Confirms that the route and controller action respond successfully.
#   - Does not re-test authentication/authorization logic, which is covered
#     separately in spec/requests/admin/admin_spec.rb.
#
# Test setup:
#   - Includes the shared context "as admin user" to simulate an authenticated
#     admin for the duration of the example. The shared context is expected to
#     provide any necessary sign-in/headers or session state required by the
#     application for admin access.
#
# Example behavior asserted:
#   - A GET request to admin_test_coverage_url returns a successful response
#     (e.g., HTTP 200 OK).
#
# Notes:
#   - Keep this spec focused and minimal: it ensures the basic operation of
#     the show endpoint under normal, authorized conditions.
#   - More detailed behavior (view contents, JSON payloads, edge-case errors)
#     should be covered by additional specs if needed.
require 'rails_helper'

RSpec.describe Admin::TestCoverageController, type: :request do
  describe "GET #show" do
    include_context "as admin user"
    it "responds successfully" do
      get admin_test_coverage_url
      expect(response).to be_successful
    end
  end
end
