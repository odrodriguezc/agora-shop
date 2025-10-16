
# Documentation for Importing::Pipelines::ProductsFromCSVToLogger
#
# A pipeline that reads product rows from a CSV file, applies a normalization
# transform, and forwards the normalized product payloads to a logger-based
# destination. The class is intended for lightweight importing/debugging of
# product feeds where persistence is not required.
#
# Key behaviour
# - Validates that a non-empty :file_path option is provided at build time.
# - Builds an Importing::Sources::CSV source configured with the provided path.
# - Applies Importing::Transforms::NormalizeProduct to each CSV row.
# - Sends transformed product objects to Importing::Destinations::Logger.
# - Registers itself in Importing::Pipelines::Registry for lookup and instantiation.
#
# Usage example:
#   pipeline = Importing::Pipelines::ProductsFromCSVToLogger.new(file_path: "path/to/products.csv")
#   pipeline.call   # runs the pipeline: source -> transforms -> destination
#
# Configuration
# - Required options:
#   - :file_path (String) — path to the CSV file to import. Must be a non-empty string.
#
# Errors
# - Raises ArgumentError if the :file_path option is missing or empty.
#
# API
# - build_source -> Importing::Sources::CSV
#   Constructs the CSV source using the validated :file_path option.
#
# - build_transforms -> Array<Importing::Transform>
#   Returns the transformation chain. Currently contains a single
#   Importing::Transforms::NormalizeProduct instance; extend or replace as needed.
#
# - build_destination -> Importing::Destinations::Logger
#   Returns a logger destination that receives transformed product payloads.
#
# - require_file_path_option! (private) -> String
#   Ensures the :file_path option is present and non-empty. Returns the path
#   or raises ArgumentError when validation fails.
#
# See also:
# - Importing::Sources::CSV
# - Importing::Transforms::NormalizeProduct
# - Importing::Destinations::Logger
# - Importing::Pipelines::Registry
#
# Notes:
# - This pipeline is geared toward development, debugging, or inspection
#   workflows. For production imports that persist records, implement a
#   destination that writes to the appropriate datastore and consider adding
#   richer validation/error-handling.
module Importing::Pipelines
  class ProductsFromCSVToLogger < Base
    REGISTER_KEY = "products_from_csv_to_logger".freeze
    Importing::Pipelines::Registry.register(REGISTER_KEY, self)
    def build_source
      file_path = require_file_path_option!
      Importing::Sources::CSV.new(path: file_path)
    end


    def build_transforms
      [ Importing::Transforms::NormalizeProduct.new, Importing::Transforms::ValidateBasic.new ]
    end

    def build_destination
      Importing::Destinations::Logger.new(model: Product)
    end
  end
end
