class AddPaymentReferenceFields < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :payment_reference, :string, :after => :paid_at
    add_column :shoppe_orders, :payment_method, :string, :after => :payment_reference
    remove_column :shoppe_orders, :payment_gateway_module
  end
end