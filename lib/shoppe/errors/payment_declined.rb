module Shoppe
  module Errors
    class PaymentDeclined < Error
      
      def initialize(options)
        @options = options
      end
      
      def message
        @options[:message]
      end
      
    end
  end
end