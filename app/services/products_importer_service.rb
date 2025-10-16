class ProductsImporterService < ApplicationService
  def initialize(file_path:, async: true)
    @file_path = file_path
    @async = async
  end

  def call
    if async
      ExecutePipelineJob.perform_later(Importing::Pipelines::ProductsFromCSVToLogger::REGISTER_KEY,  file_path: file_path)
    else
      ExecutePipelineJob.perform_now(Importing::Pipelines::ProductsFromCSVToLogger::REGISTER_KEY,  file_path: file_path)
    end
  end

  private
  attr_reader :file_path, :async
end
