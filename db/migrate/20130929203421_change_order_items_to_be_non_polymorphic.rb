class ChangeOrderItemsToBeNonPolymorphic < ActiveRecord::Migration
  def change
    rename_column :shoppe_order_items, :parent_id, :product_id
    remove_column :shoppe_order_items, :parent_type
  end
end