# Shared examples: "importing pipelines base"
#
# Purpose:
#   Reusable RSpec examples that verify the minimal contract for an importing
#   pipeline implementation. These examples assert that a pipeline is properly
#   registered, can build its source/transform/destination components, and
#   exposes a runner configuration that matches those components.
#
# Usage:
#   include_examples 'importing pipelines base', key_string, PipelineClass, optional_options_hash
#
# Required arguments:
#   key (String/Symbol)
#     The registration key passed to the pipeline instance and used to look up
#     the pipeline class in the Importing::Pipelines::Registry.
#
#   pipeline_class (Class)
#     The pipeline class under test. The shared examples expect to instantiate
#     the pipeline via pipeline_class.new(key: key, **options).
#
# Optional arguments:
#   options (Hash) — default: {}
#     Extra initialization options merged with a default file_path pointing to
#     "spec/fixtures/files/products.csv". These are forwarded into the pipeline
#     constructor as keyword arguments.
#
# Expectations / assertions provided by these examples:
#   - Registration
#     - The pipeline class must be registered in Importing::Pipelines::Registry
#       under described_class::REGISTER_KEY (i.e., the class under test exposes
#       a REGISTER_KEY constant used as the registry key).
#
#   - .build_source
#     - pipeline.build_source returns an object that responds_to :each.
#     - The returned object is a kind of Importing::Sources::Base.
#
#   - .build_transforms
#     - pipeline.build_transforms returns an Array.
#     - Each element in the array responds_to :call.
#     - Each element is a kind of Importing::Transforms::Base.
#
#   - .build_destination
#     - pipeline.build_destination returns an object that responds_to :write.
#     - The returned object is a kind of Importing::Destinations::Base.
#
#   - #to_runner_config
#     - pipeline.to_runner_config returns a Hash containing the keys :source,
#       :transforms, and :destination.
#     - The :source value's class equals pipeline.build_source.class.
#     - The :transforms array classes equal pipeline.build_transforms.map(&:class).
#     - The :destination value's class equals pipeline.build_destination.class.
#
# Notes & requirements for pipeline implementations:
#   - The pipeline must be instantiable with keyword arguments including :key
#     and any additional options used in specs.
#   - The pipeline class under test should expose a REGISTER_KEY constant that
#     matches the registry entry expected by Importing::Pipelines::Registry.
#   - Transform objects must follow the callable convention (respond_to :call).
#   - Source objects must implement Enumerable-like iteration (respond_to :each).
#   - Destination objects must implement a write interface (respond_to :write).
#
# RSpec context expectations:
#   - The examples assume the Rails/RSpec test environment and supporting
#     base classes/modules: Importing::Sources::Base,
#     Importing::Transforms::Base, Importing::Destinations::Base, and
#     Importing::Pipelines::Registry.
#
# Example:
#   include_examples 'importing pipelines base', :products, MyApp::Importing::Pipelines::ProductsPipeline, { file_path: "spec/fixtures/files/products.csv" }
#
# This shared example set is intended to ensure consistency across different
# pipeline implementations and to catch regressions in the pipeline contract
# used by the import runner.
require 'rails_helper'

RSpec.shared_examples 'importing pipelines base' do |key, pipeline_class, options = {}|
  subject(:pipeline) { pipeline_class.new(key: key, **local_options) }
  let(:local_options) { options.merge(file_path: "spec/fixtures/files/products.csv") }

  describe 'registration' do
    it 'is registered in the pipelines registry under its key' do
      fetched = Importing::Pipelines::Registry.fetch(described_class::REGISTER_KEY)
      expect(fetched).to eq(described_class)
    end
  end

  describe '.build_source' do
    it "returns a source object" do
      source = pipeline.build_source
      expect(source).to respond_to(:each)
      expect(source).to be_a_kind_of(Importing::Sources::Base)
    end
  end

  describe '.build_transforms' do
    it "return an array of transform objects" do
      transforms = pipeline.build_transforms
      expect(transforms).to be_an(Array)
      transforms.each do |transform|
        expect(transform).to respond_to(:call)
        expect(transform).to be_a_kind_of(Importing::Transforms::Base)
      end
    end
  end

  describe '.build_destination' do
    it "returns a destination object" do
      destination = pipeline.build_destination
      expect(destination).to respond_to(:write)
      expect(destination).to be_a_kind_of(Importing::Destinations::Base)
    end
  end

  describe '#to_runner_config' do
    it "returns a hash with source, transforms, and destination" do
      config = pipeline.to_runner_config
      expect(config).to be_a(Hash)
      expect(config).to have_key(:source)
      expect(config).to have_key(:transforms)
      expect(config).to have_key(:destination)
    end

    it "the config components match the built components" do
      config = pipeline.to_runner_config
      expect(config[:source].class).to eq(pipeline.build_source.class)
      expect(config[:transforms].map(&:class)).to eq(pipeline.build_transforms.map(&:class))
      expect(config[:destination].class).to eq(pipeline.build_destination.class)
    end
  end
end
