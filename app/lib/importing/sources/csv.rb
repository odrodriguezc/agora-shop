
# Importing::Sources::CSV
#
# A source adapter that reads rows from a CSV file and yields each row as a Hash.
# This class is intended to be used by the import pipeline (subclass of Base)
# to provide row-wise input from a CSV file.
#
# Defaults
# - headers: true      # treat the first row as headers and convert rows to hashes
# - encoding: "UTF-8"  # file encoding passed to CSV.foreach
# - col_sep: ","       # column separator
#
# Usage
# - Initialize with a path (String or Pathname) and optional CSV-specific options:
#     Importing::Sources::CSV.new(path: "data.csv", headers: true, encoding: "ISO-8859-1")
# - Iterate using `each` which yields a Hash for every CSV row (header => value).
#
# Constructor
# @param path [String, Pathname] Path to the CSV file to read.
# @param options [Hash] Optional CSV parsing options which override the defaults.
# @option options [Boolean] :headers (true) Whether to treat the first row as headers.
# @option options [String]  :encoding ("UTF-8") IO encoding passed to CSV.foreach.
# @option options [String]  :col_sep (",") Column separator character.
#
# Instance Methods
# #each
# @yield [Hash] Each invocation yields a row represented as a Hash (header => value).
# @return [void]
# @example
#   source = Importing::Sources::CSV.new(path: "users.csv")
#   source.each do |row|
#     # row is a Hash, e.g. { "id" => "1", "name" => "Alice" }
#   end
#
# Errors
# - Raises standard IO/File errors if the file cannot be opened (e.g. Errno::ENOENT).
# - May raise CSV::MalformedCSVError for invalid CSV content depending on Ruby's CSV parser.
#
# Notes
# - The class expects to be used in contexts that call `each` (e.g. Enumerable-like
#   import pipelines). It does not itself return an Enumerator when called without a block.
# - Options are merged with sensible defaults; pass only the options you need to override.
module Importing::Sources
  require "csv"
  class CSV < Base
    DEFAULTS = {
      headers: true,
      encoding: "UTF-8",
      col_sep: ","
    }

    def initialize(path:, **options)
      super(**options)
      @path = Pathname.new(path)
      @options = DEFAULTS.merge(options)
    end

    def each
      return enum_for(:each) unless block_given? # To support Enumerator when no block given. Ex. CSV.each.take(10)

      ::CSV.foreach(@path, headers: @options[:headers], encoding: @options[:encoding], col_sep: @options[:col_sep]) do |row|
        yield row.to_h
      end
    end
  end
end
