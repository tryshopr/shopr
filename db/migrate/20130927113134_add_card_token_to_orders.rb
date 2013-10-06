class AddCardTokenToOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :stripe_customer_token, :string
    add_column :shoppe_orders, :stripe_payment_token, :string
  end
end