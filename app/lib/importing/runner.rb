
# Runner orchestrates a simple ETL-style pipeline: it reads rows from a source,
# applies a sequence of transforms to each row and writes the resulting rows to
# a destination. Resources are cleaned up and transforms are finalized even if an
# exception occurs during processing.
#
# Responsibilities
# - Iterate over `source`, yielding individual rows.
# - For each row, apply `transforms` in order; if any transform returns `nil`,
#   that row is dropped and not written to the destination.
# - Write non-nil, transformed rows to `destination`.
# - Ensure `destination.flush` and `destination.close` are called after processing.
# - Ensure each transform's `finish` method is invoked in reverse order after
#   processing (i.e., last transform first).
#
# Expected interfaces
# - source: an object that responds to `each` and yields individual rows.
# - transforms: an Array (or Enumerable) of objects that respond to:
#     - `call(row)` -> returns a transformed row or `nil` to indicate the row
#       should be dropped.
#     - `finish` -> perform any finalization/cleanup for the transform.
# - destination: an object that responds to:
#     - `write(row)` -> persist or buffer the transformed row.
#     - `flush` -> flush any buffered writes.
#     - `close` -> release any destination resources.
#
# Public API
# - initialize(key:, source:, transforms:, destination:)
#   - key: an identifier for the run (used for logging/metrics by callers).
#   - source: see "source" interface above.
#   - transforms: see "transforms" interface above.
#   - destination: see "destination" interface above.
#
# - call
#   - Runs the import. Iterates over the source, applies transforms, writes
#     non-nil results to the destination. Guarantees resource cleanup and
#     transform finalization even on error.
#   - Notes:
#     - If a transform returns `nil` for a row, processing for that row stops
#       and the row is skipped (useful for filtering).
#     - Exceptions raised by the source, a transform, or the destination will
#       propagate to the caller, but destination flush/close and transform
#       `finish` will still be attempted via an ensure block.
#
# Internal behavior
# - apply_transforms(row) -> returns the transformed row or `nil`.
#   - Applies each transform to the current row via `reduce` semantics.
#   - Stops early and returns `nil` if any transform returns `nil`.
#
# Example
#   runner = Importing::Runner.new(
#     key: "daily_import",
#     source: csv_enumerator,
#     transforms: [NormalizeDates.new, FilterRows.new, MapFields.new],
#     destination: db_writer
#   )
#   runner.call
#
# Thread-safety / concurrency
# - The class itself does not provide internal synchronization. If multiple
#   threads will share the same transforms or destination, callers are
#   responsible for ensuring those objects are thread-safe.
#
# Error handling
# - The runner tries to perform best-effort cleanup (flush/close/finish) in an
#   ensure block; however, any exceptions raised during cleanup or finalization
#   may still surface to the caller.
module Importing
  class Runner
    def initialize(key:, source:, transforms:, destination:)
      @key = key
      @source = source
      @transforms = transforms
      @destination = destination
    end

    def call
      source.each do |row|
        transformed_row = apply_transforms(row)
        next if transformed_row.nil?

        destination.write(transformed_row)
      end
    ensure
      destination.flush
      destination.close

      transforms.reverse_each { |transform| transform.finish }
    end

    private
    attr_reader :key, :source, :transforms, :destination

    def apply_transforms(row)
      transforms.reduce(row) do |current_row, transform|
        break nil if current_row.nil?

        transform.call(current_row)
      end
    end
  end
end
