module Shoppe
  class OrdersController < Shoppe::ApplicationController
  
    before_filter { @active_nav = :orders }  
    before_filter { params[:id] && @order = Shoppe::Order.find(params[:id])}
  
    def index
      @query = Shoppe::Order.ordered.received.includes(:order_items => :ordered_item).page(params[:page]).search(params[:q])
      @orders = @query.result
    end
    
    def show
      @payments = @order.payments.to_a
    end
  
    def update
      if @order.update_attributes(params[:order].permit(:notes, :first_name, :last_name, :company, :billing_address1, :billing_address2, :billing_address3, :billing_address4, :billing_postcode, :billing_country_id, :separate_delivery_address,:delivery_name, :delivery_address1, :delivery_address2, :delivery_address3, :delivery_address4, :delivery_postcode, :delivery_country_id, :email_address, :phone_number))
        redirect_to @order, :notice => "Order has been saved successfully"
      else
        render :action => "edit"
      end
    end
  
    def search
      index
      render :action => "index"
    end
  
    def accept
      @order.accept!(current_user)
      redirect_to @order, :notice => "Order has been accepted successfully"
    end
  
    def reject
      @order.reject!(current_user)
      redirect_to @order, :notice => "Order has been rejected successfully"
    end
  
    def ship
      @order.ship!(current_user, params[:consignment_number])
      redirect_to @order, :notice => "Order has been shipped successfully"
    end
  
    def despatch_note
      render :layout => 'shoppe/printable'
    end
  
  end
end
