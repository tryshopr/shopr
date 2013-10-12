class AddPublicBooleanToProductAttributes < ActiveRecord::Migration
  def change
    add_column :shoppe_product_attributes, :public, :boolean, :default => true
  end
end