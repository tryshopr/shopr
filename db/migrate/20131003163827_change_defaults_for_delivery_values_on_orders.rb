class ChangeDefaultsForDeliveryValuesOnOrders < ActiveRecord::Migration
  def change
    change_column_default :shoppe_orders, :delivery_price, nil
    change_column_default :shoppe_orders, :delivery_tax_rate, nil
    change_column_default :shoppe_orders, :delivery_tax_amount, nil
  end
end