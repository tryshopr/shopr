class AddStockControlBooleanToProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :stock_control, :boolean, :default => true
  end
end