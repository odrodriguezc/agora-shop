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
      let(:dummy_json_string) { '{"timestamp":1760480115,"command_name":"RSpec","files":[{"filename":"/app/app/controllers/admin/base_controller.rb","covered_percent":100.0,"coverage":{"lines":[1,1,1,null,1,null,1,1,null,null,null],"branches":{}},"covered_strength":1.0,"covered_lines":6,"lines_of_code":6},{"filename":"/app/app/controllers/admin/test_coverage_controller.rb","covered_percent":52.63157894736842,"coverage":{"lines":[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,1,1,1,null,1,null,null,1,null,null,1,0,0,null,null,1,0,0,null,0,0,0,null,null,1,null,1,0,null,null,1,0,null,null],"branches":{}},"covered_strength":0.5263157894736842,"covered_lines":10,"lines_of_code":19},{"filename":"/app/app/controllers/application_controller.rb","covered_percent":71.42857142857143,"coverage":{"lines":[1,1,1,null,1,null,1,null,null,null,1,1,1,null,null,1,1,null,0,0,0,0,null,null,null],"branches":{}},"covered_strength":0.7142857142857143,"covered_lines":10,"lines_of_code":14},{"filename":"/app/app/controllers/concerns/authentication.rb","covered_percent":65.51724137931035,"coverage":{"lines":[1,1,null,1,1,1,null,null,1,1,0,null,null,null,1,1,0,null,null,1,1,null,null,1,2,null,null,1,1,null,null,1,0,0,null,null,1,0,null,null,1,0,0,0,null,null,null,1,0,0,null,null],"branches":{"[:if, 0, 29, 6, 29, 85]":{"[:then, 1, 29, 6, 29, 54]":1,"[:else, 2, 29, 6, 29, 85]":0}}},"covered_strength":0.6896551724137931,"covered_lines":19,"lines_of_code":29},{"filename":"/app/app/helpers/admin_helper.rb","covered_percent":100.0,"coverage":{"lines":[1,null],"branches":{}},"covered_strength":1.0,"covered_lines":1,"lines_of_code":1},{"filename":"/app/app/helpers/application_helper.rb","covered_percent":100.0,"coverage":{"lines":[1,null],"branches":{}},"covered_strength":1.0,"covered_lines":1,"lines_of_code":1},{"filename":"/app/app/helpers/categories_helper.rb","covered_percent":100.0,"coverage":{"lines":[1,null],"branches":{}},"covered_strength":1.0,"covered_lines":1,"lines_of_code":1},{"filename":"/app/app/helpers/products_helper.rb","covered_percent":100.0,"coverage":{"lines":[1,null],"branches":{}},"covered_strength":1.0,"covered_lines":1,"lines_of_code":1},{"filename":"/app/app/helpers/users_helper.rb","covered_percent":100.0,"coverage":{"lines":[1,null],"branches":{}},"covered_strength":1.0,"covered_lines":1,"lines_of_code":1},{"filename":"/app/app/mailers/users_mailer.rb","covered_percent":40.0,"coverage":{"lines":[1,1,0,0,0,null,null],"branches":{}},"covered_strength":0.4,"covered_lines":2,"lines_of_code":5},{"filename":"/app/app/models/application_record.rb","covered_percent":100.0,"coverage":{"lines":[1,1,null],"branches":{}},"covered_strength":1.0,"covered_lines":2,"lines_of_code":2},{"filename":"/app/app/models/current.rb","covered_percent":100.0,"coverage":{"lines":[1,1,1,null],"branches":{}},"covered_strength":1.0,"covered_lines":3,"lines_of_code":3},{"filename":"/app/app/models/role.rb","covered_percent":100.0,"coverage":{"lines":[1,1,null,1,null,null,null,null,1,null,null,null,1,null],"branches":{}},"covered_strength":1.0,"covered_lines":5,"lines_of_code":5},{"filename":"/app/app/models/session.rb","covered_percent":100.0,"coverage":{"lines":[1,1,null],"branches":{}},"covered_strength":1.0,"covered_lines":2,"lines_of_code":2},{"filename":"/app/app/models/user.rb","covered_percent":100.0,"coverage":{"lines":[1,1,1,1,1,null,1,null,1,1,null,5,null,null,1,1,null,1,null,1,2,null,null],"branches":{}},"covered_strength":1.3571428571428572,"covered_lines":14,"lines_of_code":14},{"filename":"/app/app/policies/admin_policy.rb","covered_percent":100.0,"coverage":{"lines":[null,null,1,null,null,null,1,1,null,null,1,1,1,1,1,null,1,null,1,1,null,null],"branches":{"[:\"\u0026.\", 0, 20, 4, 20, 27]":{"[:then, 1, 20, 4, 20, 27]":1,"[:else, 2, 20, 4, 20, 27]":0}}},"covered_strength":1.0,"covered_lines":11,"lines_of_code":11},{"filename":"/app/app/policies/application_policy.rb","covered_percent":87.5,"coverage":{"lines":[1,1,null,1,1,1,null,null,1,1,0,null,null],"branches":{"[:\"\u0026.\", 0, 11, 4, 11, 27]":{"[:then, 1, 11, 4, 11, 27]":0,"[:else, 2, 11, 4, 11, 27]":0}}},"covered_strength":0.875,"covered_lines":7,"lines_of_code":8},{"filename":"/app/app/services/application_service.rb","covered_percent":62.5,"coverage":{"lines":[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,1,1,1,null,1,0,0,0,null,null,null,1,null,null,null,1,0,null,null,1,6,null,null,1,0,null,null,1,0,null,null],"branches":{}},"covered_strength":0.9375,"covered_lines":10,"lines_of_code":16},{"filename":"/app/app/services/users/assign_default_role.rb","covered_percent":100.0,"coverage":{"lines":[null,null,null,null,null,null,null,null,null,null,null,null,1,1,1,2,null,2,null,null,null],"branches":{"[:unless, 0, 16, 6, 16, 37]":{"[:else, 1, 16, 6, 16, 37]":2,"[:then, 2, 16, 6, 16, 12]":0}}},"covered_strength":1.4,"covered_lines":5,"lines_of_code":5},{"filename":"/app/app/services/users/base.rb","covered_percent":100.0,"coverage":{"lines":[1,1,1,6,null,null,1,1,null,null],"branches":{}},"covered_strength":1.8333333333333333,"covered_lines":6,"lines_of_code":6},{"filename":"/app/app/services/users/onboard.rb","covered_percent":100.0,"coverage":{"lines":[null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,1,1,1,2,2,null,null,null],"branches":{}},"covered_strength":1.4,"covered_lines":5,"lines_of_code":5},{"filename":"/app/app/services/users/send_welcome_email.rb","covered_percent":100.0,"coverage":{"lines":[1,1,1,2,null,2,null,null,null],"branches":{"[:unless, 0, 4, 6, 4, 44]":{"[:else, 1, 4, 6, 4, 44]":2,"[:then, 2, 4, 6, 4, 9]":0}}},"covered_strength":1.4,"covered_lines":5,"lines_of_code":5}],"metrics":{"covered_percent":79.375,"covered_strength":0.93125,"covered_lines":127,"total_lines":160}}' }

      let(:coverage_data) { JSON.parse(dummy_json_string) }

      before do
        allow(TestCoverage::ReportService).to receive(:call).and_return(coverage_data)
        get admin_test_coverage_report_path
      end

      it "loads coverage data into @coverage_data" do
        expect(assigns(:coverage_data)).to eq(coverage_data)
      end

      it "responds successfully" do
        expect(response).to be_successful
      end
    end

    context "when the report service raises a ServiceError" do
      before do
        allow(TestCoverage::ReportService).to receive(:call).and_raise(ApplicationService::ServiceError.new("failed to load"))
        get admin_test_coverage_report_path
      end

      it "redirects and sets an alert with the error message" do
        expect(response).to have_http_status(:redirect)
        expect(flash[:alert]).to match(/failed to load/)
      end
    end
  end
end
