# Admin::TestCoverageController
#
# This controller is responsible for managing and displaying code coverage reports
# in the admin section of the application. It provides actions to view the coverage
# dashboard, generate new coverage data by running tests, and inspect detailed
# line-by-line coverage for specific files.
#
# Actions:
# - `show`: Displays the main coverage dashboard.
# - `report`: Displays a detailed coverage report. Requires coverage data to be present.
# - `run_tests`: Triggers the test suite to run in the background and generate new coverage data.
# - `file`: Displays line-by-line coverage details for a specific file. Requires coverage data to be present.
#
# Filters:
# - `ensure_coverage_data_present`: Ensures that coverage data is loaded before accessing
#   the `report` and `file` actions.
#
# Error Handling:
# - Handles `ApplicationService::ServiceError` exceptions by redirecting to the main
#   coverage page with an alert message.
# - Redirects to the main page with a flash message for coverage loading errors.
# - Renders a 404 error with plain text for file-specific errors.
# - Logs unexpected errors and redirects with a generic error message.
#
# Dependencies:
# - Uses `TestCoverage::ReportService` to load coverage data.
# - Uses `TestCoverage::FileDetailsService` to fetch file-specific coverage details.
# - Enqueues `RunCoverageTestsJob` to run tests asynchronously.
class Admin::TestCoverageController < Admin::BaseController
  before_action :ensure_coverage_data_present, only: [ :report, :file ]
  rescue_from ApplicationService::ServiceError, with: :handle_service_error

  def show
  end

  def report
  end

  def run_tests
    RunCoverageTestsJob.perform_later
    redirect_to admin_test_coverage_path, notice: "Tests are running in the background. Refresh this page in a moment to see the updated coverage report."
  end

  def file
    file_path = params.require(:path)
    file_result = TestCoverage::FileDetailsService.call(coverage_data: @coverage_data, file_path: file_path)

    @file_data = file_result[:file_data]
    @source_lines = file_result[:source_lines]
    @coverage_lines = file_result[:coverage_lines]
  end

  private

  def ensure_coverage_data_present
    @coverage_data  = TestCoverage::ReportService.call
  end

  def handle_service_error(error)
    redirect_to admin_test_coverage_path, alert: "An unexpected error occurred: #{error.message}"
  end
end
