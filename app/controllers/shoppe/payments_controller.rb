module Shoppe
  class PaymentsController < ApplicationController
    
    before_filter { @order = Shoppe::Order.find(params[:order_id]) }
    
    def create
      payment = @order.payments.build(params[:payment].permit(:amount, :method, :reference))
      if payment.save
        redirect_to @order, :notice => "Payment has been added successfully"
      else
        redirect_to @order, :alert => payment.errors.full_messages.to_sentence
      end
    end
    
  end
end
