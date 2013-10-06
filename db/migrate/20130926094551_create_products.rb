class CreateProducts < ActiveRecord::Migration
  def change
    create_table :shoppe_products do |t|
      t.integer :product_category_id
      t.string :title, :sku, :permalink
      t.text :description, :short_description
      t.boolean :active, :default => true
      
      t.decimal :weight, :precision => 8, :scale => 3, :default => 0.0
      t.decimal :price, :precision => 8, :scale => 2, :default => 0.0
      t.decimal :vat_rate, :precision => 8, :scale => 2, :default => 0.0
      
      t.integer :stock, :default => 0
      
      t.timestamps
    end
  end
end
