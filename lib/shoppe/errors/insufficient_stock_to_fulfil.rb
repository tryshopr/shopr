module Shoppe
  module Errors
    class InsufficientStockToFulfil < Error
      
      def initialize(options)
        @options = options
      end
      
      def order
        @options[:order]
      end
      
      def out_of_stock_items
        @options[:out_of_stock_items]
      end
      
    end
  end
end