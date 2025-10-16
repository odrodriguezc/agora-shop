
# This service is responsible for retrieving detailed information about a specific file's
# test coverage and its source code lines. It processes coverage data and source files
# to provide insights into the file's coverage status.
#
# @example Usage
#   coverage_data = { "files" => [...] }
#   file_path = "path/to/file.rb"
#   service = TestCoverage::FileDetailsService.new(coverage_data: coverage_data, file_path: file_path)
#   result = service.call
#
# @param coverage_data [Hash] The coverage data hash containing information about files and their coverage.
# @param file_path [String] The relative path to the file for which coverage details are being retrieved.
#
# @raise [Errno::ENOENT] If the source file cannot be found or read.
# @return [Hash] A hash containing:
#   - :file_data [Hash] The coverage data for the specified file.
#   - :source_lines [Array<String>] The source code lines of the specified file.
#   - :coverage_lines [Array<Integer, nil>] The coverage data for each line of the file.
#
# @note If the file is not found in the coverage data, the service will fail with a `:not_found` status.
module TestCoverage
  class FileDetailsService < ApplicationService
    def initialize(coverage_data:, file_path:)
      @coverage_data = coverage_data
      @file_path = file_path
    end

    def call
      file_data = find_file(@file_path)
      fail!("File not found in coverage data", status: :not_found, context: { file: @file_path }) unless file_data

      source_lines = get_source_lines(@file_path)
      coverage_lines = Array(file_data.dig("coverage", "lines"))
    rescue Errno::ENOENT => e
      Rails.logger.error("[TestCoverage::FileDetailsService] Source file not found: #{@file_path}")
      Rails.logger.error(e.message)
      fail!("Error reading source file", context: { file: @file_path.to_s, error: e.message })
    else
      success({ file_data: file_data, source_lines: source_lines, coverage_lines: coverage_lines })
    end

    private
    def find_file(file_path)
      @coverage_data["files"].find do |file|
        file["filename"] == Rails.root.join(file_path).to_s
      end
    end

    def get_source_lines(file_path)
      File.readlines(file_path).map(&:chomp)
    end
  end
end
