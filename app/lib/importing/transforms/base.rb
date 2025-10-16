
# Base class for importing transforms.
#
# This class provides a lightweight interface for transforming or processing
# individual rows during an import process. It is intended to be subclassed;
# subclasses must implement the `#call` method to define how a single row is
# handled. An optional `#finish` hook is provided for any cleanup or final
# ization after all rows have been processed.
#
# Usage
#   - Subclass Importing::Transforms::Base
#   - Implement #call(row) to transform/process each input row
#   - Optionally override #finish to perform end-of-stream work
#
# Constructor
# @param options [Hash] configuration options for the transform. They are stored
#   in the instance variable `@options` for use by subclasses.
#
# #call
# @abstract
# @param row [Object] the input row to be processed (can be a Hash, Array, or
#   any domain-specific object). Subclasses must return the transformed value
#   or perform side effects as appropriate.
# @raise [NotImplementedError] if the subclass does not implement this method.
#
# #finish
# Optional lifecycle hook called after all rows have been processed. Subclasses
# may override this method to flush buffered data, close resources, or emit
# summary information. The default implementation is a no-op.
#
# Example
#   # class MyTransform < Importing::Transforms::Base
#   #   def call(row)
#   #     # transform row
#   #   end
#   #
#   #   def finish
#   #     # optional cleanup
#   #   end
#   # end
module Importing::Transforms
  class Base
    def initialize(**options)
      @options = options
    end

    def call(row)
      raise NotImplementedError, "#{self.class}#call must be implemented in a subclass"
    end

    def finish
      # optional: override in subclass if needed
    end
  end
end
