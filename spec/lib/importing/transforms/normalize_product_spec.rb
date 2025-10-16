require 'rails_helper'

RSpec.describe Importing::Transforms::NormalizeProduct do
  describe '#normalize_headers' do
    it 'normalizes the headers of a product row' do
      transform = described_class.new
      input_row = {
        " Name " => "Sample Product",
        "Price" => "19.99",
        " In Stock " => "true"
      }
      expected_output = {
        "name" => "Sample Product",
        "price" => "19.99",
        "in_stock" => "true"
      }

      output_row = transform.send(:normalize_headers, input_row)
      expect(output_row).to eq(expected_output)
    end
  end

  describe '#map_headers' do
    it 'maps normalized headers to product attributes' do
      transform = described_class.new
      normalized_row = {
        "name" => "Sample Product",
        "description" => "A great product",
        "price_unit" => "19.99",
        "stock" => "100"
      }
      expected_mapped = {
        title: "Sample Product",
        description: "A great product",
        price: "19.99",
        stock_quantity: "100"
      }

      mapped_row = transform.send(:map_headers, normalized_row)
      expect(mapped_row).to eq(expected_mapped)
    end
  end

  describe '#default_values' do
    it 'assigns default values for missing price and stock' do
      transform = described_class.new
      input_row = {
        title: "Sample Product",
        description: "A great product"
      }
      expected_output = {
        title: "Sample Product",
        description: "A great product",
        price: "0.0",
        stock_quantity: "0"
      }

      output_row = transform.send(:default_values, input_row)
      expect(output_row).to eq(expected_output)
    end
  end

  describe '#call' do
    it 'normalizes and maps a product row and assigns default values' do
      transform = described_class.new
      input_row = {
        " Name " => "Sample Product",
        "Description" => "A great product",
        " Price Unit " => "19.99",
        " Stock " => ""
      }
      expected_output = {
        title: "Sample Product",
        description: "A great product",
        price: "19.99",
        stock_quantity: "0"
      }

      output_row = transform.call(input_row)
      expect(output_row).to eq(expected_output)
    end
  end
end
