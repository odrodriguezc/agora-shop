require 'rails_helper'

RSpec.describe ProductsImporterService, type: :service do
  describe '#call' do
    it 'imports products from a CSV file' do
      file_path = "spec/fixtures/files/products_csv_to_import.csv"
      ProductsImporterService.call(file_path: file_path)

      ## run the service
    end
  end
end
