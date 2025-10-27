require 'rails_helper'

RSpec.describe Importing::Pipelines::ProductsFromCSVToDatabase do
  it_behaves_like 'importing pipelines base', 'products_from_csv_to_database', described_class

  describe '#to_runner_config' do
    subject(:pipeline) do
      described_class.new(key: 'products_from_csv_to_database', **{ file_path: '/tmp/products.csv' })
    end

    let(:runner_config) { pipeline.to_runner_config }

    it 'builds the correct runner config' do
      expect(runner_config[:key]).to eq('products_from_csv_to_database')
      expect(runner_config[:source]).to be_a(Importing::Sources::CSV)
      expect(runner_config[:source].instance_variable_get(:@path).to_s).to eq('/tmp/products.csv')
      expect(runner_config[:transforms]).to contain_exactly(Importing::Transforms::NormalizeProduct, Importing::Transforms::ValidateBasic)
      expect(runner_config[:destination]).to be_a(Importing::Destinations::DatabaseUpsert)
    end
  end

  describe '#build_source' do
    it_behaves_like 'require file_path option', pipeline_class: described_class, key: 'products_from_csv_to_database'
  end

  describe '#build_transforms' do
    subject(:pipeline) { described_class.new(key: 'products_from_csv_to_database', **{ file_path: '/tmp/products.csv' }) }

    let(:transforms) { pipeline.build_transforms }

    it 'returns the correct transforms' do
      expect(transforms).to contain_exactly(
        an_instance_of(Importing::Transforms::NormalizeProduct),
        an_instance_of(Importing::Transforms::ValidateBasic)
      )
    end
  end

  describe '#build_destination' do
    subject(:pipeline) { described_class.new(key: 'products_from_csv_to_database', **{ file_path: '/tmp/products.csv' }) }

    let(:destination) { pipeline.build_destination }

    it 'returns the correct destination' do
      expect(destination).to be_a(Importing::Destinations::DatabaseUpsert)
      expect(destination.instance_variable_get(:@model)).to eq(Product)
    end
  end
end
