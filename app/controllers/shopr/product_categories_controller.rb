module Shopr
  class ProductCategoriesController < Shopr::ApplicationController
    before_action { @active_nav = :product_categories }
    before_action { params[:id] && @product_category = Shopr::ProductCategory.find(params[:id]) }

    def index
      @product_categories_without_parent = Shopr::ProductCategory.without_parent.ordered
    end

    def new
      @product_category = Shopr::ProductCategory.new
    end

    def create
      @product_category = Shopr::ProductCategory.new(safe_params)
      if @product_category.save
        redirect_to :product_categories, flash: { notice: t('shopr.product_category.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit
    end

    def update
      if @product_category.update(safe_params)
        redirect_to [:edit, @product_category], flash: { notice: t('shopr.product_category.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @product_category.destroy
      redirect_to :product_categories, flash: { notice: t('shopr.product_category.destroy_notice') }
    end

    private

    def safe_params
      file_params = [:file, :parent_id, :role, :parent_type, file: []]
      params[:product_category].permit(:name, :permalink, :description, :parent_id, :permalink_includes_ancestors, attachments: [image: file_params])
    end
  end
end
