module Importing::Destinations
  class Database < Base
    def initialize(**options)
      super
      @buffer = []
    end

    # Row is a hash of attributes => value
    def write(row)
      buffer << extract_attributes(row)
      row
    end

    def write_batch(rows)
      rows.each { |row| buffer << extract_attributes(row) }
      flush
    end

    # TODO: Add tests for flush and close behavior
    def flush
      return if buffer.empty?

      model.upsert_all(buffer)
      buffer.clear
    end

    private

    attr_reader :buffer

    def extract_attributes(row)
      row.slice(*model::PERMITTED_ATTRIBUTES)
    end
  end
end
