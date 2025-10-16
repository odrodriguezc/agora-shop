module Importing::Transforms
  class ValidateBasic < Base
    def initialize
      @errors = []
    end

    def call(row)
      return reject(row, "title", "must be a non-empty string, got: #{row['title'].inspect}") unless non_empty_string?(row["title"])
      return reject(row, "price", "must be a positive number or zero, got: #{row['price'].inspect}") unless positive_or_zero?(row["price"])
      return reject(row, "stock_quantity", "must be a positive number or zero, got: #{row['stock_quantity'].inspect}") unless positive_or_zero?(row["stock_quantity"])
      row
    end

    def finish
      Rails.logger.warn("Dropped #{@errors.count} rows: #{@errors}") if @errors.any?
    end

    private
    def positive_or_zero?(value)
      num = ActiveModel::Type::Float.new.cast(value) # "lala" -> nil, "" -> nil
      num.is_a?(Numeric) && num.finite? && num >= 0
    end

    def non_empty_string?(value)
      value.is_a?(String) && !value.strip.empty?
    end

    def reject(row, field, message)
      @errors << { row: row, field: field, message: message }
    end
  end
end
