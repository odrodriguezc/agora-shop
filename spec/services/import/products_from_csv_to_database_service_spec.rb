require 'rails_helper'

RSpec.describe Import::ProductsFromCSVToDatabaseService, type: :service do
  describe '#call' do
    let (:file_path) { "spec/fixtures/files/products_csv_to_import.csv" }
    before do
      Product.delete_all
    end
    context "when data is valid" do
      it 'imports products from a CSV file and database assigns sku' do
        described_class.call(file_path: file_path, batch_size: 5, async: false)

        expect(Product.count).to eq(10)
        expect(Product.pluck(:title)).to include("Product 1", "Product 2", "Product 3", "Product 4", "Product 5", "Product 6", "Product 7", "Product 8", "Product 9", "Product 10")
        expect(Product.pluck(:sku).compact.count).to eq(10)
      end
    end
  end
end
