class AddIndexOnPermalinks < ActiveRecord::Migration
  def change
    add_index :shoppe_products, :permalink, unique: true
    add_index :shoppe_product_categories, :permalink, unique: true
  end
end
