module Shoppe
  class OrdersController < Shoppe::ApplicationController
  
    before_filter { @active_nav = :orders }  
    before_filter { params[:id] && @order = Shoppe::Order.find(params[:id])}
  
    def index
      @query = Shoppe::Order.ordered.received.includes(:order_items => :ordered_item).page(params[:page]).search(params[:q])
      @orders = @query.result
    end
    
    def new
      @order = Shoppe::Order.new
      @order.order_items.build(:ordered_item_type => 'Shoppe::Product')
    end
    
    def create
      Shoppe::Order.transaction do
        @order = Shoppe::Order.new(safe_params)
        @order.status = 'confirming'
        if !request.xhr? && @order.save
          @order.confirm!
          redirect_to @order, :notice => "Order has been created successfully"
        else
          @order.order_items.build(:ordered_item_type => 'Shoppe::Product')
          render :action => "new"
        end
      end
    rescue Shoppe::Errors::InsufficientStockToFulfil => e
      flash.now[:alert] = "Insufficient stock to order #{e.out_of_stock_items.map { |t| t.ordered_item.full_name }.to_sentence}. Quantities have been updated to max total stock available."
      render :action => 'new'
    end
    
    def show
      @payments = @order.payments.to_a
    end
  
    def update
      @order.attributes = safe_params
      if !request.xhr? && @order.update_attributes(safe_params)
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
    rescue Shoppe::Errors::PaymentDeclined => e
      redirect_to @order, :alert => e.message
    end
  
    def reject
      @order.reject!(current_user)
      redirect_to @order, :notice => "Order has been rejected successfully"
    rescue Shoppe::Errors::PaymentDeclined => e
      redirect_to @order, :alert => e.message
    end
  
    def ship
      @order.ship!(params[:consignment_number], current_user)
      redirect_to @order, :notice => "Order has been shipped successfully"
    end
  
    def despatch_note
      render :layout => 'shoppe/printable'
    end
  
    private
    
    def safe_params
      params[:order].permit(
        :first_name, :last_name, :company,
        :billing_address1, :billing_address2, :billing_address3, :billing_address4, :billing_postcode, :billing_country_id,
        :separate_delivery_address,
        :delivery_name, :delivery_address1, :delivery_address2, :delivery_address3, :delivery_address4, :delivery_postcode, :delivery_country_id,
        :delivery_price, :delivery_service_id, :delivery_tax_amount,
        :email_address, :phone_number,
        :notes,
        :order_items_attributes => [:ordered_item_id, :ordered_item_type, :quantity, :unit_price, :tax_amount, :id, :weight]
      )
    end
  end
end
