class StockLevelAdjustmentsShouldBePolymorphic < ActiveRecord::Migration
  def change
    rename_column :shoppe_stock_level_adjustments, :product_id, :item_id
    add_column :shoppe_stock_level_adjustments, :item_type, :string, :after => :item_id
  end
end