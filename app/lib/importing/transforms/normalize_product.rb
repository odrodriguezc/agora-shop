module Importing::Transforms
  class NormalizeProduct < Base
    def call(row)
      current_row = normalize_headers(row)
      current_row = map_headers(current_row)
      default_values(current_row)
    end


    private
    def normalize_headers(row)
      row.transform_keys { |key| key.to_s.strip.downcase.gsub(" ", "_") }
    end

    # after normalize header map the headers names with expected product attributes
    # normalized headers => id,name,description,price_unit,stock,external_id
    # product attributes =>"title","description", "price", "stock_quantity", "sku"

    def map_headers(row)
      { title: row["name"],
       description: row["description"],
       price: row["price_unit"],
       stock_quantity: row["stock"] }
    end

    # price and stock to 0 if missing
    # handle "" and nil cases
    # assigning default values 0.0 for price and 0 for stock_quantity if value is Empty
    def default_values(row)
      row[:price] = "0.0" if row[:price].nil? || row[:price].strip.empty?
      row[:stock_quantity] = "0" if row[:stock_quantity].nil? || row[:stock_quantity].strip.empty?
      row
    end
  end
end
