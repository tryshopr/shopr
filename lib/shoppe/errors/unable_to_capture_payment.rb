module Shoppe
  module Errors
    class UnableToCapturePayment < Error
      
      def initialize(options)
        @options = options
      end
      
    end
  end
end