class RenameVatToTax < ActiveRecord::Migration
  def change
    rename_column :shoppe_products, :vat_rate, :tax_rate
    rename_column :shoppe_orders, :delivery_vat_rate, :delivery_tax_rate
    rename_column :shoppe_orders, :delivery_vat_amount, :delivery_tax_amount
    rename_column :shoppe_order_items, :vat_amount, :tax_amount
    rename_column :shoppe_order_items, :vat_rate, :tax_rate
    rename_column :shoppe_delivery_services, :vat_rate, :tax_rate
    
  end
end