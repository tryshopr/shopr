module Shoppe
  class TaxRatesController < Shoppe::ApplicationController
  
    before_filter { @active_nav = :tax_rates }
    before_filter { params[:id] && @tax_rate = Shoppe::TaxRate.find(params[:id]) }
  
    def index
      @tax_rates = Shoppe::TaxRate.ordered.all
    end
  
    def new
      @tax_rate = Shoppe::TaxRate.new
      render :action => "form"
    end
  
    def create
      @tax_rate = Shoppe::TaxRate.new(safe_params)
      if @tax_rate.save
        redirect_to :tax_rates, :flash => {:notice => "Tax rate has been created successfully"}
      else
        render :action => "form"
      end
    end
  
    def edit
      render :action => "form"
    end
  
    def update
      if @tax_rate.update(safe_params)
        redirect_to [:edit, @tax_rate], :flash => {:notice => "Tax rate has been updated successfully"}
      else
        render :action => "form"
      end
    end
  
    def destroy
      @tax_rate.destroy
      redirect_to :tax_rates, :flash => {:notice => "Tax rate has been removed successfully"}
    end
  
    private
  
    def safe_params
      params[:tax_rate].permit(:name, :rate, :address_type, :country_ids => [])
    end
  
  end
end
