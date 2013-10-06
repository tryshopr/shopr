class AddPaymentGatewayToOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :payment_gateway_module, :string
  end
end