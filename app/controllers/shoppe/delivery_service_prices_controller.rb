module Shoppe
  class DeliveryServicePricesController < Shoppe::ApplicationController

    before_filter { @active_nav = :delivery_services }
    before_filter { @delivery_service = Shoppe::DeliveryService.find(params[:delivery_service_id])}
    before_filter { params[:id] && @delivery_service_price = @delivery_service.delivery_service_prices.find(params[:id])}

    def index
      @delivery_service_prices = @delivery_service.delivery_service_prices.ordered
    end

    def new
      @delivery_service_price = @delivery_service.delivery_service_prices.build
    end

    def create
      @delivery_service_price = @delivery_service.delivery_service_prices.build(safe_params)
      if @delivery_service_price.save
        redirect_to [@delivery_service, :delivery_service_prices], :notice => t('shoppe.delivery_service_prices.create_notice')
      else
        render :action => "new"
      end
    end

    def update
      if @delivery_service_price.update(safe_params)
        redirect_to [@delivery_service, :delivery_service_prices], :notice => t('shoppe.delivery_service_prices.update_notice')
      else
        render :action => "edit"
      end
    end

    def destroy
      @delivery_service_price.destroy
      redirect_to [@delivery_service, :delivery_service_prices], :notice => t('shoppe.delivery_service_prices.destroy_notice')
    end

    private

    def safe_params
      params[:delivery_service_price].permit(:price, :cost_price, :tax_rate_id, :min_weight, :max_weight, :code, :country_ids => [])
    end

  end
end
