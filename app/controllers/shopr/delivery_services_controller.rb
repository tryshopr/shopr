module Shopr
  class DeliveryServicesController < Shopr::ApplicationController
    before_action { @active_nav = :delivery_services }
    before_action { params[:id] && @delivery_service = Shopr::DeliveryService.find(params[:id]) }

    def index
      @delivery_services = Shopr::DeliveryService.all
    end

    def new
      @delivery_service = Shopr::DeliveryService.new
    end

    def create
      @delivery_service = Shopr::DeliveryService.new(safe_params)
      if @delivery_service.save
        redirect_to :delivery_services, flash: { notice: t('shopr.delivery_services.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit; end

    def update
      if @delivery_service.update(safe_params)
        redirect_to [:edit, @delivery_service], flash: { notice: t('shopr.delivery_services.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @delivery_service.destroy
      redirect_to :delivery_services, flash: { notice: t('shopr.delivery_services.destroy_notice') }
    end

    private

    def safe_params
      params[:delivery_service].permit(:name, :code, :active, :default, :courier, :tracking_url)
    end
  end
end
