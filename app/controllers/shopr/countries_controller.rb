module Shopr
  class CountriesController < Shopr::ApplicationController
    before_action { @active_nav = :countries }
    before_action { params[:id] && @country = Shopr::Country.find(params[:id]) }

    def index
      @countries = Shopr::Country.ordered
    end

    def new
      @country = Shopr::Country.new
    end

    def create
      @country = Shopr::Country.new(safe_params)
      if @country.save
        redirect_to :countries, flash: { notice: t('shopr.countries.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def update
      if @country.update(safe_params)
        redirect_to [:edit, @country], flash: { notice: t('shopr.countries.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @country.destroy
      redirect_to :countries, flash: { notice: t('shopr.countries.destroy_notice') }
    end

    private

    def safe_params
      params[:country].permit(:name, :code2, :code3, :continent, :tld, :currency, :eu_member)
    end
  end
end
