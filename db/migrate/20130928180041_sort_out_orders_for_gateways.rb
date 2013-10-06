class SortOutOrdersForGateways < ActiveRecord::Migration
  def change
    remove_column :shoppe_orders, :stripe_customer_token
    remove_column :shoppe_orders, :payment_reference
    remove_column :shoppe_orders, :payment_method
  end
end