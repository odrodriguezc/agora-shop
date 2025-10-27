module Importing::Pipelines
  class ProductsFromCSVToDatabase < Base
    REGISTER_KEY = "products_from_csv_to_database".freeze
    Importing::Pipelines::Registry.register(REGISTER_KEY, self)

    def build_source
      file_path = require_file_path_option!
      Importing::Sources::CSV.new(path: file_path)
    end

    def build_transforms
      [ Importing::Transforms::NormalizeProduct.new, Importing::Transforms::ValidateBasic.new ]
    end

    def build_destination
      Importing::Destinations::DatabaseUpsert.new(model: Product)
    end
  end
end
