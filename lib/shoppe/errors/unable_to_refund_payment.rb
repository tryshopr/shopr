module Shoppe
  module Errors
    class UnableToRefundPayment < Error
      
      def initialize(options)
        @options = options
      end
      
    end
  end
end