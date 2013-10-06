class AddFeaturedBooleanToProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :featured, :boolean, :default => false
  end
end