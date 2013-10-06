class AddPaymentDateToOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :paid_at, :datetime, :after => :received_at
  end
end