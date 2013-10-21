module Shoppe
  class OrdersController < Shoppe::ApplicationController
  
    before_filter { @active_nav = :orders }  
    before_filter { params[:id] && @order = Shoppe::Order.find(params[:id])}
  
    def index
      @query = Shoppe::Order.ordered.received.includes(:order_items => :product).page(params[:page]).search(params[:q])
      @orders = @query.result
    end
  
    def update
      @order.update_attributes!(params[:order].permit(:notes))
      redirect_to @order, :notice => "Order has been saved successfully"
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
  
    def pay
      @order.pay!(params[:payment_reference], params[:payment_method].blank? ? 'Unknown' : params[:payment_method])
      redirect_to @order, :notice => "Order has been marked as paid successfully"
    end
  
  end
end
