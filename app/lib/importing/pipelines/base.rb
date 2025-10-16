
# Base class for import pipeline builders.
# This class provides a small DSL for composing a pipeline configuration that a runner
# can consume. It is intended to be subclassed; concrete pipelines must provide a source
# and a destination and may optionally provide transforms.
#
# Responsibilities
# - Store a pipeline key and arbitrary options.
# - Require subclasses to implement build_source and build_destination.
# - Provide a default no-op build_transforms which returns an empty array.
# - Combine the parts into a runner-friendly Hash via to_runner_config.
#
# Example
#   class MyPipeline < Importing::Pipelines::Base
#     def build_source
#       { type: :csv, path: options[:path] }
#     end
#
#     def build_transforms
#       [{ type: :normalize }, { type: :map_fields }]
#     end
#
#     def build_destination
#       { type: :database, table: options[:table] }
#     end
#   end
#
#   pipeline = MyPipeline.new(key: :products, path: "data.csv", table: "products")
#   pipeline.to_runner_config
#   # => {
#   #   key: :products,
#   #   source: { type: :csv, path: "data.csv" },
#   #   transforms: [{ type: :normalize }, { type: :map_fields }],
#   #   destination: { type: :database, table: "products" }
#   #   }
#
# YARD tags
# @abstract
# @attr_reader [String, Symbol] key A unique identifier for the pipeline.
# @attr_reader [Hash] options Arbitrary options passed to the pipeline.
#
# @param key [String, Symbol] (required) the pipeline key used by the runner
# @param options [Hash] additional configuration used by concrete pipeline implementations
#
# @return [Hash] to_runner_config A Hash containing :key, :source, :transforms and :destination
#
# @raise [NotImplementedError] build_source and build_destination raise by default and must be implemented in subclasses.
#
# Subclassing guidance
# - Implement build_source to return the source description (usually a Hash or object the runner understands).
# - Implement build_destination to return the destination description.
# - Override build_transforms when any transformation steps are required; otherwise the default is an empty Array.
module Importing::Pipelines
  class Base
    attr_reader :key, :options

    def initialize(key:, **options)
      @key = key
      @options = options
    end

    def build_source
      raise NotImplementedError, "#{self.class}#build_source must be implemented"
    end

    def build_transforms
      []
    end

    def build_destination
      raise NotImplementedError, "#{self.class}#build_destination must be implemented"
    end

    def to_runner_config
      {
        key: key,
        source: build_source,
        transforms: build_transforms,
        destination: build_destination
      }
    end
  end
end
