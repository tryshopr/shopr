class AddCustomerToShoppeOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :customer_id, :integer
  end
end