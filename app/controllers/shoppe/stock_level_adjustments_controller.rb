module Shoppe
  class StockLevelAdjustmentsController < ApplicationController

    SUITABLE_OBJECTS = ['Shoppe::Product']
    before_filter do
      raise Shoppe::Error, "Invalid item_type (must be one of #{SUITABLE_OBJECTS.to_sentence})" unless SUITABLE_OBJECTS.include?(params[:item_type])
      @item = params[:item_type].constantize.find(params[:item_id].to_i)
    end
    before_filter { params[:id] && @sla = @item.stock_level_adjustments.find(params[:id].to_i) }
    
    def index
      @stock_level_adjustments = @item.stock_level_adjustments.ordered.page(params[:page])
      @new_sla = @item.stock_level_adjustments.build if @new_sla.nil?
    end
    
    def create
      @new_sla = @item.stock_level_adjustments.build(params[:stock_level_adjustment].permit(:description, :adjustment))
      if @new_sla.save
        redirect_to stock_level_adjustments_path(:item_id => params[:item_id], :item_type => params[:item_type]), :notice => "Adjustment has been added successfully"
      else
        index
        flash.now[:alert] = @new_sla.errors.full_messages.to_sentence
        render :action => "index"
      end
    end
    
  end
end
