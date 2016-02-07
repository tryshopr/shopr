module Shoppe
  class Error < StandardError
    def initialize(options = {})
      @options = if options.is_a?(String)
                   { message: options }
                 else
                   options
      end
    end

    def message
      @options[:message]
    end

    attr_reader :options
  end
end
