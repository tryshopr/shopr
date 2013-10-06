module Shoppe
  module PaymentGateways
    class Abstract
    
      def initialize(order)
        @order = order
      end
      
      def on_checkout_form_submission(params)
        {}
      end
    
      def on_receive
      end
    
      def on_accept
      end
    
      def on_reject
      end
      
      def self.descendants
        ObjectSpace.each_object(Class).select { |klass| klass < self }
      end
      
      private
      
      def order
        @order
      end
      
    end
  end
end
