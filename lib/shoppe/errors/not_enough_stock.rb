module Shoppe
  module Errors
    class NotEnoughStock < Error
      
      def initialize(options)
        @options = options
      end
      
      def available_stock
        @options[:product].stock
      end
      
      def requested_stock
        @options[:requested_stock]
      end
      
    end
  end
end