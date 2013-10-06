class Shoppe::OrdersController < Shoppe::ApplicationController
  
  before_filter { @active_nav = :orders }  
  before_filter { params[:id] && @order = Shoppe::Order.find(params[:id])}
  
  def index
    @query = Shoppe::Order.ordered.received.includes(:order_items => :product).page(params[:page]).search(params[:q])
    @orders = @query.result
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
  
end
