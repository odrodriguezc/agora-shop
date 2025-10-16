module Importing::Transforms
  class NormalizeProduct < Base
    def call(row)
      current_row = normalize_headers(row)
      current_row = map_headers(current_row)
      default_values(current_row)
    end


    private
    def normalize_headers(row)
      row.to_h.transform_keys { |key| key.to_s.strip.downcase.gsub(" ", "_") }
    end

    # Map normalized headers to expected product attributes (symbol keys)
    def map_headers(row)
      {
        title: row["name"],
        description: row["description"],
        price: row["price_unit"],
        stock_quantity: row["stock"]
      }
    end

    # price and stock to "0.0" / "0" if missing; handle "" and nil
    def default_values(row)
      # ensure symbol keyed result
      result = row.each_with_object({}) { |(k, v), h| h[k.to_sym] = v }

      result[:price] = "0.0" if result[:price].nil? || result[:price].to_s.strip.empty?
      result[:stock_quantity] = "0" if result[:stock_quantity].nil? || result[:stock_quantity].to_s.strip.empty?
      result
    end
  end
end
