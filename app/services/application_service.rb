# The ApplicationService class serves as a base class for service objects in the application.
# It provides a standard structure for implementing service objects, including error handling
# and a consistent interface for invoking services.
#
# Subclasses must implement the `call` method to define the service's behavior.
#
# Example usage:
#   class MyService < ApplicationService
#     def initialize(param1, param2)
#       @param1 = param1
#       @param2 = param2
#     end
#
#     def call
#       # Service logic here
#       success("Operation successful")
#     rescue SomeError => e
#       fail!("Operation failed", status: :bad_request, context: { error: e.message })
#     end
#   end
#
#   result = MyService.call(arg1, arg2)
#
# Methods:
# - `initialize(*args, **kwargs)`: Constructor for initializing the service object.
# - `call`: Abstract method that must be implemented by subclasses to define the service logic.
# - `self.call(*args, **kwargs, &block)`: Class method to instantiate and invoke the service.
# - `fail!(message, status: :internal_server_error, context: {})`: Raises a `ServiceError` with the given message, status, and context.
# - `success(payload = true)`: Returns the given payload to indicate a successful operation.
#
# Inner Classes:
# - `ServiceError`: Custom error class for handling service-specific errors. Includes:
#   - `status`: HTTP-like status code or symbol representing the error type.
#   - `context`: Additional context or metadata about the error.
class ApplicationService
  class ServiceError < StandardError
    attr_reader :status, :context

    def initialize(message, status: :internal_server_error, context: {})
      super(message)
      @status = status
      @context = context
    end
  end

  def initialize(*args, **kwargs); end

  # Simulate an abstract method by raising NotImplementedError.
  def call
    raise NotImplementedError, "Subclasses must implement the call method"
  end

  def self.call(*args, **kwargs, &block)
    new(*args, **kwargs, &block).call
  end

  def fail!(message, status: :internal_server_error, context: {})
    raise ServiceError.new(message, status: status, context: context)
  end

  def success(payload = true)
    payload
  end
end
