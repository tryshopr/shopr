module Shoppe
  class Error < StandardError

    def initialize(options = {})
      if options.is_a?(String)
        @options = {:message => options}
      else
        @options = options
      end
    end
    
    def message
      @options[:message]
    end
    
    def options
      @options
    end
    
  end  
end
