class RefactorOrderItemsToAllowAnyProduct < ActiveRecord::Migration
  def change
    rename_column :shoppe_order_items, :product_id, :ordered_item_id
    add_column :shoppe_order_items, :ordered_item_type, :string, :after => :ordered_item_id
  end
end