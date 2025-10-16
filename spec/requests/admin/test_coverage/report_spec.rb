# Spec: Admin::TestCoverageController (request spec)
#
# Purpose:
#   Verifies the behavior of the GET #report action for admin users.
#
# Test setup:
#   - Runs as an admin user via `include_context "as admin user"`.
#   - Uses a realistic JSON payload (stored as `dummy_json_string`) parsed into
#     `coverage_data` to simulate code-coverage report output.
#   - Stubs TestCoverage::ReportService.call to control service responses.
#
# Contexts and expectations:
#   1. when coverage data is available
#      - Stubs TestCoverage::ReportService.call to return the parsed `coverage_data`.
#      - Performs GET to admin_test_coverage_report_path.
#      - Expects the controller to assign @coverage_data with the parsed JSON.
#      - Expects a successful HTTP response (2xx).
#
#   2. when the report service raises a ServiceError
#      - Stubs TestCoverage::ReportService.call to raise ApplicationService::ServiceError.
#      - Performs GET to admin_test_coverage_report_path.
#      - Expects the controller to redirect (non-2xx response).
#      - Expects flash[:alert] to include the service error message.
#
# Notes:
#   - This is a request spec (type: :request), exercising the full stack
#     (routing -> controller) rather than isolated unit-level controller tests.
#   - The tests focus on happy-path data loading and graceful error handling
#     when the underlying reporting service fails.
require 'rails_helper'

RSpec.describe Admin::TestCoverageController, type: :request do
  describe "GET #report" do
    include_context "as admin user"

    context "when coverage data is available" do
      let(:dummy_json_string) { '{"timestamp":1760480115,"command_name":"RSpec","files":[{"filename":"/app/app/controllers/admin/base_controller.rb","covered_percent":100.0,"coverage":{"lines":[1,1,1,null,1,null,1,1,null,null,null],"branches":{}},"covered_strength":1.0,"covered_lines":6,"lines_of_code":6}],"metrics":{"covered_percent":79.375,"covered_strength":0.93125,"covered_lines":127,"total_lines":160}}' }
      let(:coverage_data) { JSON.parse(dummy_json_string) }

      before do
        allow(TestCoverage::ReportService).to receive(:call).and_return(coverage_data)
        get admin_test_coverage_report_path
      end

      it "responds successfully" do
        expect(response).to be_successful
      end

      it "displays coverage metrics in the response" do
        expect(response.body).to match(/79.4/)
        expect(response.body).to match(/admin\/base_controller\.rb/)
      end

      it "calls the report service" do
        expect(TestCoverage::ReportService).to have_received(:call)
      end
    end

    context "when the report service raises a ServiceError" do
      before do
        allow(TestCoverage::ReportService).to receive(:call).and_raise(ApplicationService::ServiceError.new("failed to load"))
        get admin_test_coverage_report_path
      end

      it "redirects" do
        expect(response).to have_http_status(:redirect)
      end

      it "sets an alert with the error message" do
        expect(flash[:alert]).to match(/failed to load/)
      end
    end
  end
end
