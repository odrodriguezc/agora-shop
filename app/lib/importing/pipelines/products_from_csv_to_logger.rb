
# ProductsFromCSVToLogger
#
# Pipeline that imports product records from a CSV file into the application's
# ActiveRecord-backed destination. This pipeline is registered under the key
# "products_from_csv" when the class is loaded, so it can be looked up and
# instantiated via Importing::Pipelines::Registry.
#
# Responsibilities
# - Build a CSV source that reads rows from a file path provided in options.
# - Provide an ordered list of transformations to apply to each CSV row
#   (parsing, normalization, attribute mapping, validation).
# - Provide a destination configuration that persists normalized product data
#   into the database (typically via an ActiveRecord model).
#
# Configuration
# - options (Hash)
#   - :file_path (String, required) — path to the CSV file to import. The
#     pipeline will attempt to fetch this key; a KeyError will be raised if it
#     is missing. Implement callers should ensure the path is validated and
#     accessible.
#
# Behavior and return types
# - build_source -> Importing::Sources::CSV
#   Constructs and returns a CSV source object initialized with the provided
#   file path. The source is responsible for iterating CSV rows and providing
#   them to the transform chain.
#
# - build_transforms -> Array
#   Returns an array of transform objects/configs. Each transform should accept
#   a row (or a representation of row data) and return either a transformed
#   row, nil to skip the row, or raise an error for terminal failures. Typical
#   transforms include header normalization, type coercion, trimming/cleaning
#   fields, mapping CSV columns to product attributes, and lightweight
#   validations.
#
# - build_destination -> Object (ActiveRecord destination config)
#   Returns the destination configuration responsible for upserting or creating
#   product records in the database. Implementations are expected to handle
#   deduplication (by SKU or unique identifier), transactional persistence,
#   and mapping transformed row attributes to the Product model.
#
# Error handling
# - Missing :file_path will cause options.fetch(:file_path) to raise KeyError.
#   Consider rescuing and re-raising a more descriptive ImportError or logging a
#   user-friendly message upstream.
# - Transform and destination stages should be deterministic and should surface
#   recoverable errors (validation failures) vs terminal errors (I/O or DB
#   connectivity) so the import runner can decide on retry/rollback behavior.
#
# Extensibility notes
# - Add or replace transforms in build_transforms to adapt to different CSV
#   schemas, locales, or business rules (e.g., price conversions, taxonomy
#   mapping).
# - build_destination should encapsulate all ActiveRecord interaction so that
#   tests can stub or swap a fake destination for unit testing transforms and
#   source behavior.
#
# Example
#   pipeline = Importing::Pipelines::Registry.fetch("products_from_csv").new(
#     options: { file_path: "/tmp/products.csv" }
#   )
#   pipeline.run
#
# See also
# - Importing::Sources::CSV for source contract
# - Importing::Pipelines::Registry for pipeline discovery/registration
#
# TODO
# - Improve error message when file_path is missing and validate file existence
# - Implement and document expected transform shape (callable protocol)
module Importing::Pipelines
  class ProductsFromCSVToLogger < Base
    REGISTER_KEY = "products_from_csv_to_logger".freeze
    # Register the pipeline with a unique key
    Importing::Pipelines::Registry.register(REGISTER_KEY, self)
    def build_source
      # return source config for products CSV
      # TODO: handle error if file_path is missing
      Importing::Sources::CSV.new(path: options.fetch(:file_path))
    end

    def build_transforms
      # return array of transform configs for products CSV
      # e.g., parsing, cleaning, mapping fields
      [ Importing::Transforms::NormalizeProduct.new ]
    end

    def build_destination
      Importing::Destinations::Logger.new()
    end
  end
end
