
# Base class for import sources.
#
# Subclasses of Importing::Sources::Base provide a uniform interface for
# iterating over items produced by different import mechanisms (files,
# APIs, feeds, etc.). This base class stores initialization options and
# defines the abstract #each method that subclasses must implement.
#
# Example:
#   class MySource < Importing::Sources::Base
#     def each
#       # yield imported items
#     end
#   end
#
#   MySource.new(path: "data.csv").each { |item| handle(item) }
#
# @param options [Hash] arbitrary configuration options for the source
# @option options [String] :path path or identifier for the data source (implementation-specific)
# @option options [Symbol] :encoding character encoding (implementation-specific)
# @api public
#
# @!attribute [r] options
#   @return [Hash] the raw options passed to the source
#
# Initializes the source with the provided keyword options.
# @param options [Hash] keyword arguments that configure the source
# @return [void]
#
# Iterates over imported items.
# Subclasses must implement this method. Implementations should yield each
# imported item to the given block. If no block is given, implementations are
# encouraged to return an Enumerator.
#
# @abstract
# @yield [item] each imported item
# @raise [NotImplementedError] when not implemented by a subclass
# @return [Enumerator, nil] an Enumerator when no block is given, otherwise nil
module Importing::Sources
  class Base
    # TODO : Errors
    # Importing::SourceError < StandardError
    # Importing::SourceUnavailable (fichier/url introuvable)
    # Importing::SourceFormatError (CSV/JSON invalide)
    def initialize(**options)
      @options = options
    end

    def each
      raise NotImplementedError, "#{self.class}#each must be implemented in a subclass"
    end

    def each_batch(batch_size)
      raise ArgumentError, "batch_size must be a positive integer" unless batch_size.is_a?(Integer) && batch_size.positive?
      return enum_for(:each_batch, batch_size) unless block_given?

      each.each_slice(batch_size) { |batch| yield batch }
    end
  end
end
