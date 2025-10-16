
# This job is responsible for running the RSpec test suite with coverage generation
# and clearing the test coverage cache. It executes the RSpec command in the test
# environment, redirecting the output to a log file.
#
# Queue: default
#
# Methods:
# - perform: Executes the RSpec tests and clears the test coverage cache.
class RunCoverageTestsJob < ApplicationJob
  queue_as :default

  def perform
    # Run RSpec with coverage generation
    system("cd #{Rails.root} && RAILS_ENV=test bundle exec rspec > log/test.log 2>&1")
    TestCoverage::ReportService.clear_cache
  end
end
