
# Logger destination for the importing pipeline.
#
# Writes a single informational log entry for each row it receives. This
# destination is intended for debugging and audit purposes — it does not
# mutate or persist the row, it only emits a message to the application's
# logger (Rails.logger).
#
# The logged message is constructed by joining a fixed prefix with the
# string representation of the supplied row.
#
# Example:
#   logger = Importing::Destinations::Logger.new
#   logger.write({ id: 42, name: "Example" })
#
# @param row [Object] The import row to log. Any object that responds to
#   to_s (for human-readable output) is acceptable; commonly a Hash or Array.
# @return [nil] The method's purpose is the side effect of logging; it does
#   not return a meaningful value.
# @note Logs at the info level via Rails.logger.info. Behavior and formatting
#   of the final output depend on the configured Rails logger.
# @see Rails.logger
# @api public
module Importing::Destinations
  class Logger < Base
    def write(row)
      Rails.logger.info([ "Importing::Destinations::Logger#write called with row:", row ].join(" "))
    end
  end
end
