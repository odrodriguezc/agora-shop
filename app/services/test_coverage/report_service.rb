
# This service is responsible for handling test coverage report data.
# It reads a JSON coverage report file, caches the parsed data, and provides
# a mechanism to clear the cache.
#
# Constants:
# - REPORT_FILE: The path to the coverage report file, configurable via
#   environment variables `COVERAGE_REPORT_PATH` and `COVERAGE_REPORT_FILE`.
# - CACHE_KEY: The cache key used to store the parsed coverage report data.
# - EXPIRES_IN: The cache expiration time, currently set to 1 hour (configurable via TODO).
#
# Public Methods:
# - call: Fetches the coverage report data from the cache or reads and parses
#   the report file if not cached.
# - self.clear_cache: Clears the cached coverage report data.
#
# Private Methods:
# - parse_coverage_file: Reads and parses the JSON coverage report file.
#   Logs errors and raises exceptions if the file cannot be read or parsed.
module TestCoverage
  class ReportService < ApplicationService
    REPORT_FILE = Rails.root.join(
      ENV.fetch("COVERAGE_REPORT_PATH", "coverage"),
      ENV.fetch("COVERAGE_REPORT_FILE", "coverage.json")
    )
    CACHE_KEY = "admin:coverage:report_data"
    EXPIRES_IN = 1.hours # TODO: make configurable via env var

    def call
      Rails.cache.fetch(CACHE_KEY, expires_in: EXPIRES_IN) do
        parse_coverage_file
      end
    end

    def self.clear_cache
      Rails.cache.delete(CACHE_KEY)
    end

    private
    def parse_coverage_file
      JSON.parse(File.read(REPORT_FILE))
    rescue JSON::ParserError => e
      Rails.logger.error("[TestCoverage] error parsing report file: #{e.message}")
      fail!("Error parsing coverage report file:", context: { file: REPORT_FILE, error: e.message })
    rescue StandardError => e
      Rails.logger.error("[TestCoverage] Error reading report file: #{e.message}")
      fail!("Error reading coverage report file:", context: { file: REPORT_FILE, error: e.message })
    end
  end
end
