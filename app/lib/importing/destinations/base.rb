
# Importing::Destinations::Base
#
# Abstract base class that defines the interface for destination writers used by
# the importing pipeline. Subclasses should implement the concrete writing
# behaviour (e.g. writing to a file, a database, an API, etc.).
#
# @abstract
#
# Initialization
# @param options [Hash] an options hash passed to the destination. Subclasses
#   may expect specific keys (connection info, formatting options, batch size,
#   etc.). Options are stored on @options for subclass use.
#
# Instance methods
# #write(data)
#   - Abstract method that must be implemented by subclasses.
#   - @param data [Object] the payload to write. The concrete type/shape
#     (single record, Hash, Array of records, etc.) depends on the destination
#     implementation and the importer that calls it.
#   - @raise [NotImplementedError] if not implemented by a subclass.
#
# #flush
#   - Optional hook for subclasses to flush any buffered data to the underlying
#     resource. Default implementation is a no-op.
#   - Useful when destinations buffer writes for batching or performance.
#
# #close
#   - Optional hook for subclasses to release resources (close files, close DB
#     connections, terminate network sockets, etc.). Default implementation is
#     a no-op.
#
# Notes
# - Subclasses should ensure idempotency and proper error handling for
#   transient failures (retries, partial failures) as required by the import
#   process.
# - Implementations should document any expected option keys and the expected
#   shape of `data` accepted by #write.
#
# Example (conceptual)
#   # Subclasses implement #write, optionally override #flush and #close.
#   class CsvDestination < Importing::Destinations::Base
#     def write(data) ... end
#     def flush ... end
#     def close ... end
#   end
#
module Importing::Destinations
  class Base
    def initialize(**options)
      @options = options
    end

    def write(data)
      raise NotImplementedError, "#{self.class}#write must be implemented in a subclass"
    end

    def flush
      # optional: override in subclass if needed
    end

    def close
      # optional: override in subclass if needed
    end
  end
end
