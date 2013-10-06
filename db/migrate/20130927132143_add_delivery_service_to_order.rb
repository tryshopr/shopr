class AddDeliveryServiceToOrder < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :delivery_service_id, :integer
    add_column :shoppe_orders, :delivery_price, :decimal, :precision => 8, :scale => 2, :default => 0.0
    add_column :shoppe_orders, :delivery_vat_rate, :decimal, :precision => 8, :scale => 2, :default => 0.0
    add_column :shoppe_orders, :delivery_vat_amount, :decimal, :precision => 8, :scale => 2, :default => 0.0
  end
end