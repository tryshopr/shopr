class Shoppe::ProductsController < Shoppe::ApplicationController
  
  before_filter { @active_nav = :products }
  before_filter { params[:id] && @product = Shoppe::Product.find(params[:id]) }
  
  def index
    @products = Shoppe::Product.includes(:stock_level_adjustments, :default_image, :product_category).order(:title).group_by(&:product_category).sort_by { |cat,pro| cat.name }
  end
  
  def new
    @product = Shoppe::Product.new
  end
  
  def create
    @product = Shoppe::Product.new(safe_params)
    if @product.save
      redirect_to :products, :flash => {:notice => "Product has been created successfully"}
    else
      render :action => "new"
    end
  end
  
  def edit
  end
  
  def update
    if @product.update(safe_params)
      redirect_to [:edit, @product], :flash => {:notice => "Product has been updated successfully"}
    else
      render :action => "edit"
    end
  end
  
  def destroy
    @product.destroy
    redirect_to :products, :flash => {:notice => "Product has been removed successfully"}
  end
  
  def stock_levels
    @stock_level_adjustments = @product.stock_level_adjustments.ordered.page(params[:page])
    if request.post?
      @new_sla = @product.stock_level_adjustments.build(params[:stock_level_adjustment].permit(:description, :adjustment))
      if @new_sla.save
        redirect_to [:stock_levels, @product], :notice => "Stock level adjustment has been recorded"
      else
        flash.now[:alert] = @new_sla.errors.full_messages.to_sentence
      end
    else
      @new_sla = @product.stock_level_adjustments.build
    end
  end
  
  private
  
  def safe_params
    params[:product].permit(:product_category_id, :title, :sku, :permalink, :description, :short_description, :weight, :price, :cost_price, :tax_rate_id, :stock_control, :default_image_file, :data_sheet_file, :active, :featured, :in_the_box, :product_attributes_array => [:key, :value, :searchable, :public])
  end
  
end
