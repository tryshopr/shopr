class CreateOrderItems < ActiveRecord::Migration
  def change
    create_table :shoppe_order_items do |t|
      t.integer :order_id
      t.string :parent_type
      t.integer :parent_id
      t.integer :quantity, :default => 1
      t.decimal :unit_price, :precision => 8, :scale => 2
      t.decimal :vat_amount, :precision => 8, :scale => 2
      t.decimal :vat_rate, :precision => 8, :scale => 2
      t.decimal :weight, :precision => 8, :scale => 3, :default => 0
      t.timestamps
    end
  end
end
