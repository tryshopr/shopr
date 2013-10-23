class AddDefaultVarientToProducts < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :default, :boolean, :default => false
  end
end