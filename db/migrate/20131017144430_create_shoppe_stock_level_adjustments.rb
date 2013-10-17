class CreateShoppeStockLevelAdjustments < ActiveRecord::Migration
  def up
    create_table :shoppe_stock_level_adjustments do |t|
      t.integer :product_id
      t.string :description
      t.integer :adjustment, :default => 0
      t.string :parent_type
      t.integer :parent_id
      t.timestamps
    end
    remove_column :shoppe_products, :stock
  end
  
  def down
    drop_table :shoppe_stock_level_adjustments
    add_column :shoppe_products, :stock, :integer, :default => 0, :before => :weight
  end
end