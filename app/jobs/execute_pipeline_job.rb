
 # Executes a registered import pipeline inside an ActiveJob.
 #
 # This job is intended to be enqueued and run by ActiveJob (queue_as :default).
 # It looks up a pipeline class by key from Importing::Pipelines::Registry,
 # instantiates the pipeline with the provided options (symbolized), builds an
 # Importing::Runner using the pipeline's runner configuration, and executes it.
 #
 # Usage:
 #   # Enqueue to run asynchronously
 #   ExecutePipelineJob.perform_later('my_pipeline', foo: 'bar')
 #
 #   # Run immediately (synchronous execution via ActiveJob adapter)
 #   ExecutePipelineJob.perform_now('my_pipeline', foo: 'bar')
 #
 # Parameters:
 # @param pipeline_key [String, Symbol] The registry key identifying the pipeline to run.
 # @param options [Hash] Optional parameters passed to the pipeline initializer.
 #   - Keys will be symbolized before being forwarded to the pipeline.
 #
 # Behavior and side effects:
 # - Fetches the pipeline class from Importing::Pipelines::Registry.fetch(pipeline_key).
 # - Instantiates the pipeline with key: pipeline_key plus the provided options.
 # - Builds an Importing::Runner using pipeline.to_runner_config and calls runner.call.
 # - The runner is expected to perform the import/work and may produce side effects
 #   (database writes, external API calls, file operations, etc.).
 #
 # Return value:
 # @return [Object] The value returned by Importing::Runner#call (whatever the runner returns).
 #
 # Errors:
 # @raise [KeyError, Registry::NotFoundError] If the pipeline_key is not registered (subject to Registry implementation).
 # @raise [StandardError] Any errors raised by pipeline initialization or runner execution will bubble up
 #   unless ActiveJob/error handling middleware rescues them.
 #
 # Notes:
 # - Ensure the pipeline identified by pipeline_key implements .new(key:, **options) and #to_runner_config.
 # - Options are symbolized with options.symbolize_keys before being passed through.
 # - Consider adding retry/backoff logic or custom error handling via ActiveJob configuration if imports should be retried.
 #
 # See also:
 # - Importing::Pipelines::Registry
 # - Importing::Runner
 class ExecutePipelineJob < ApplicationJob
  queue_as :default

  def perform(pipeline_key, options = {})
    pipeline_class = Importing::Pipelines::Registry.fetch(pipeline_key)
    pipeline = pipeline_class.new(key: pipeline_key, **options.symbolize_keys)

    runner = Importing::Runner.new(**pipeline.to_runner_config.merge(options))
    runner.call
  end
 end
