module Shoppe
  module Errors
    class InappropriateDeliveryService < Error
      
      def initialize(options)
        @options = options
      end
      
    end
  end
end