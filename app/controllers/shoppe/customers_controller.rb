module Shoppe
  class CustomersController < Shoppe::ApplicationController
    before_filter { @active_nav = :customers }
    before_filter { params[:id] && @customer = Shoppe::Customer.find(params[:id]) }

    def index
      @query = Shoppe::Customer.ordered.page(params[:page]).search(params[:q])
      @customers = @query.result
    end

    def new
      @customer = Shoppe::Customer.new
    end

    def show
      @addresses = @customer.addresses.ordered.load
      @orders = @customer.orders.ordered.load
    end

    def create
      @customer = Shoppe::Customer.new(safe_params)
      if @customer.save
        redirect_to @customer, flash: { notice: t('shoppe.customers.created_successfully') }
      else
        render action: 'new'
      end
    end

    def update
      if @customer.update(safe_params)
        redirect_to @customer, flash: { notice: t('shoppe.customers.updated_successfully') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @customer.destroy
      redirect_to customers_path, flash: { notice: t('shoppe.customers.deleted_successfully') }
    end

    def search
      index
      render action: 'index'
    end

    private

    def safe_params
      params[:customer].permit(:first_name, :last_name, :company, :email, :phone, :mobile)
    end
  end
end
