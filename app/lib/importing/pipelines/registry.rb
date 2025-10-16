
# Registry for importing pipelines.
#
# This class provides a simple in-memory registry for pipeline classes used by
# the importing subsystem. Keys are stored as strings and mapped to class
# objects. Intended to be used via the module-level (class) API.
#
# Usage:
#   Importing::Pipelines::Registry.register(:csv, CsvImportPipeline)
#   pipeline_class = Importing::Pipelines::Registry.fetch(:csv)
#
# Behavior:
# - register(key, klass): stores klass under key.to_s. Overwrites any existing
#   entry for the same key.
# - fetch(key): returns the class previously registered for key.to_s.
#   Raises KeyError if no entry exists for the given key.
#
# Notes:
# - The backing storage is a simple in-memory Hash memoized in a class
#   instance variable ( @storage ). It is not synchronized; if you need
#   thread-safety in concurrent environments, add appropriate synchronization.
# - The storage accessor is marked private; consumers should use the public
#   register and fetch methods only.
#
# Parameters:
# - key (Object): Any object that responds to to_s; the stringified value is
#   used as the registry key.
# - klass (Class): The pipeline class to register.
#
# Exceptions:
# - KeyError: raised by fetch when the requested key is not present in the
#   registry.
#
# Examples:
#   Importing::Pipelines::Registry.register('json', JsonImportPipeline)
#   Importing::Pipelines::Registry.fetch('json') # => JsonImportPipeline
module Importing::Pipelines
  class Registry
    def self.register(key, klass)
      storage[key.to_s] = klass
    end

    def self.fetch(key)
      storage.fetch(key.to_s) do
        raise KeyError, "Pipeline not found for key: #{key}"
      end
    end

    private

    def self.storage
      @storage ||= {}
    end
  end
end
