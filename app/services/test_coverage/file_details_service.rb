
# This service is responsible for retrieving detailed information about a specific file
# from the test coverage data. It ensures that the file exists in the coverage data,
# reads its source lines, and extracts the corresponding coverage lines.
#
# Example usage:
#   service = TestCoverage::FileDetailsService.new(coverage_data: coverage_data, file_path: file_path)
#   result = service.call
#
# Dependencies:
# - Rails.root: Used to resolve absolute paths.
# - Rails.logger: Used to log errors when the source file is not found.
#
# Methods:
# - initialize(coverage_data:, file_path:): Initializes the service with the coverage data and file path.
# - call: Executes the service logic to retrieve file details.
# - absolute_path(path): Resolves the absolute path of a given file path.
# - normalized_path(path): Normalizes the file path relative to the Rails root.
# - coverage_path_candidates(filename): Generates possible path candidates for matching coverage data.
# - find_file(file_path): Finds the file in the coverage data using various path candidates.
# - get_source_lines(file_path): Reads and returns the source lines of the file.
#
# Error Handling:
# - Raises a failure with a "File not found in coverage data" message if the file is not found.
# - Logs an error and raises a failure with an "Error reading source file" message if the source file cannot be read.
#
# Returns:
# - On success: A hash containing `file_data`, `source_lines`, and `coverage_lines`.
# - On failure: An error message with additional context.
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
    rescue Errno::ENOENT => error
      resolved_path = absolute_path(@file_path)
      Rails.logger.error("[TestCoverage::FileDetailsService] Source file not found: #{resolved_path}")
      fail!("Error reading source file", context: { file: resolved_path.to_s, error: error.message })
    else
      success({ file_data: file_data, source_lines: source_lines, coverage_lines: coverage_lines })
    end

    private

    def absolute_path(path)
      pathname = Pathname.new(path)
      pathname.absolute? ? pathname : Rails.root.join(pathname)
    end

    def normalized_path(path)
      cleaned = absolute_path(path).cleanpath.to_s
      cleaned.start_with?("#{Rails.root}/") ? cleaned.delete_prefix("#{Rails.root}/") : cleaned
    end

    def coverage_path_candidates(filename)
      raw = Pathname.new(filename).cleanpath.to_s
      candidates = [ raw ]
      candidates << raw.delete_prefix("#{Rails.root}/") if raw.start_with?("#{Rails.root}/")
      candidates << raw.delete_prefix("/app/") if raw.start_with?("/app/")
      candidates.uniq
    rescue ArgumentError
      [ filename ]
    end

    def find_file(file_path)
      absolute = absolute_path(file_path).cleanpath.to_s
      relative = normalized_path(file_path)

      @coverage_data["files"].find do |file|
        candidates = coverage_path_candidates(file["filename"])
        candidates.include?(absolute) || candidates.include?(relative)
      end
    end

    def get_source_lines(file_path)
      File.readlines(absolute_path(file_path)).map(&:chomp)
    end
  end
end
