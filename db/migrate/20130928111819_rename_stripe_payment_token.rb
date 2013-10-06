class RenameStripePaymentToken < ActiveRecord::Migration
  def change
    rename_column :shoppe_orders, :stripe_payment_token, :payment_reference
    add_column :shoppe_orders, :payment_method, :string, :after => :payment_reference
  end
end