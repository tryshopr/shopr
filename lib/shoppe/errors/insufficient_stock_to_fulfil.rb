module Shoppe
  module Errors
    class InsufficientStockToFulfil < Error
      
      def order
        @options[:order]
      end
      
      def out_of_stock_items
        @options[:out_of_stock_items]
      end
      
    end
  end
end