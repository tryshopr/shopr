require 'stripe'

module Shoppe
  module PaymentGateways
    class Stripe < Abstract
      
      #
      # Set the Stripe API key as specified in the config
      #
      ::Stripe.api_key = Shoppe.config[:stripe][:api_key]
      
      #
      # Return the name of the gateway
      #
      def name
        'Stripe'
      end
      
      #
      # The payment reference is the charge token from Stripe.
      #
      def payment_reference
        @payment_reference ||= order.properties['stripe_charge_token']
      end
      
      #
      # When a checkout is requested
      #
      def on_checkout(params)
        if order.properties['stripe_customer_token']
          {:action => 'redirect', :redirect_url => '/checkout/confirm'}
        else
          {:action => 'view', :view_name => 'stripe'}
        end
      end
      
      #
      # When the checkout form is submitted, we will attempt to convert a token into 
      # a customer object. 
      #
      def on_checkout_form_submission(params)
        if params['stripe_customer_token'] && params['stripe_customer_token'] =~ /\Atok/
          customer = ::Stripe::Customer.create(:description => "Customer for Order #{order.id}", :card => params['stripe_customer_token'])
          order.properties['stripe_customer_token']   = customer.id
          order.properties['stripe_cvc_check']        = customer.cards.first.cvc_check
          order.properties['stripe_address_check']    = customer.cards.first.address_line1_check
          order.properties['stripe_zip_check']        = customer.cards.first.address_zip_check
          order.properties['card_number']             = customer.cards.first.last4
        elsif params['stripe_customer_token'] =~ /\Acus/
          order.properties['stripe_customer_token'] = params['stripe_customer_token']
        end
      rescue ::Stripe::CardError => e
        raise Shoppe::Errors::PaymentDeclined, :message => e.message
      end
      
      #
      # When an order is received, we will create the Stripe charge and store the returned object with the
      # order properties. If there is an decline error, we will clear the customer token stored with the
      # customer which will give us the option to add a new card.
      #
      def on_receive
        charge = ::Stripe::Charge.create(
                            :customer => order.properties['stripe_customer_token'],
                            :amount => order.total_in_pence,
                            :currency => Shoppe.config[:stripe][:currency],
                            :capture => false
                          )
        order.properties['stripe_charge_token'] = charge.id
      rescue ::Stripe::CardError => e
        order.properties['stripe_customer_token'] = nil
        order.save!
        raise Shoppe::Errors::PaymentDeclined, :message => e.message
      end
      
      #
      # When an order is accepted, the charge which we pre-authorised in the receive callback, needs to be 
      # captured. This will capture the amount or raise an error as appropriate.
      #
      def on_accept
        raise Shoppe::Errors::UnableToCapturePayment, :order => order, :message => "There is no existing charge for this order." if charge.nil?
        charge.capture
      rescue ::Stripe::CardError => e
        raise Shoppe::Errors::UnableToCapturePayment, :order => order, :exception => e
      end
      
      #
      # When an order is rejected, we must refund the payment straight away to avoid locking the customer's
      # funds for 7 days (when it expires with Stripe).
      #
      def on_reject
        raise Shoppe::Errors::UnableToCapturePayment, :order => order, :message => "There is no existing charge for this order." if charge.nil?
        charge.refund
      rescue ::Stripe::CardError => e
        raise Shoppe::Errors::UnableToRefundPayment, :order => order, :exception => e
      end
      
      private
      
      
      #
      # The stripe customer object for the order
      #
      def customer
        @customer ||= ::Stripe::Customer.retrieve(order.properties['stripe_customer_token'])
      end
      
      #
      # The stripe card object for the order
      #
      def card
        @card ||= customer.cards.first
      end

      # 
      # The stripe card object for the order
      #
      def charge
        return nil if order.properties['stripe_charge_token'].blank?
        @charge ||= ::Stripe::Charge.retrieve(order.properties['stripe_charge_token'])
      end
    
    end
  end
end
