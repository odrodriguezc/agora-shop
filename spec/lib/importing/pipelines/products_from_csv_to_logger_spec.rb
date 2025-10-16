# Spec for Importing::Pipelines::ProductsFromCSVToLogger
#
# Purpose
# - Ensure the pipeline implementation conforms to the shared importing-pipeline contract
#   and that it produces the correct runner configuration for importing products from CSV
#   and sending them to a logger destination.
#
# Behaviors verified
# - It includes the shared examples 'importing pipelines base' to validate common pipeline
#   behavior (registration, required options, error handling, etc.).
#
# #to_runner_config
# - When instantiated with a key and a file_path, the pipeline should build a runner
#   configuration hash with the following expectations:
#   - :key => the pipeline key identifying this pipeline.
#   - :source => an Importing::Sources::CSV instance whose internal path matches the
#     provided CSV file path.
#   - :transforms => an array where every element is an instance of
#     Importing::Transforms::NormalizeProduct (the product-normalization transform).
#   - :destination => an Importing::Destinations::Logger instance (the sink for logged
#     import output).
#
# Notes
# - The spec focuses on shape and types of the runner config rather than internal
#   implementation details; it checks the source path via the source object's stored
#   path and verifies transform/destination classes to ensure correct pipeline wiring.
require 'rails_helper'

RSpec.describe Importing::Pipelines::ProductsFromCSVToLogger do
  it_behaves_like 'importing pipelines base', 'products_from_csv_to_logger', described_class

  describe '#to_runner_config' do
    subject(:pipeline) do
      described_class.new(key: 'products_from_csv_to_logger', **{ file_path: '/tmp/products.csv' })
    end

    let(:runner_config) { pipeline.to_runner_config }

    it 'builds the correct runner config' do
      expect(runner_config[:key]).to eq('products_from_csv_to_logger')
      expect(runner_config[:source]).to be_a(Importing::Sources::CSV)
      expect(runner_config[:source].instance_variable_get(:@path).to_s).to eq('/tmp/products.csv')
      expect(runner_config[:transforms]).to contain_exactly(Importing::Transforms::NormalizeProduct, Importing::Transforms::ValidateBasic)
      expect(runner_config[:destination]).to be_a(Importing::Destinations::Logger)
    end
  end

  describe '#build_source' do
    context 'when built source without required options' do
      subject(:pipeline) do
        described_class.new(key: 'products_from_csv_to_logger')
      end
      it 'raises an ArgumentError' do
        expect {
          pipeline.build_source
        }.to raise_error(ArgumentError, /requires a non-empty :file_path option/)
      end
    end
  end
end
