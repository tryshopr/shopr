class AddIpAddressToOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :ip_address, :string
  end
end