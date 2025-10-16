module Import
  class ProductsFromCSVToDatabaseService < ApplicationService
    def initialize(file_path:, async: true, batch_size: 1000)
      @file_path = file_path
      @async = async
      @batch_size = batch_size
    end

    def call
      if async
        ExecutePipelineJob.perform_later(Importing::Pipelines::ProductsFromCSVToDatabase::REGISTER_KEY,  **options)
      else
        ExecutePipelineJob.perform_now(Importing::Pipelines::ProductsFromCSVToDatabase::REGISTER_KEY,  **options)
      end
    end

    private
    attr_reader :file_path, :async, :batch_size

    def options
      {
        file_path: file_path,
        batch_size: batch_size
      }
    end
  end
end
