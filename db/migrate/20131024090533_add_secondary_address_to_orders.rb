class AddSecondaryAddressToOrders < ActiveRecord::Migration
  def change
    rename_column :shoppe_orders, :address1, :billing_address1
    rename_column :shoppe_orders, :address2, :billing_address2
    rename_column :shoppe_orders, :address3, :billing_address3
    rename_column :shoppe_orders, :address4, :billing_address4
    rename_column :shoppe_orders, :postcode, :billing_postcode
    rename_column :shoppe_orders, :country_id, :billing_country_id

    add_column :shoppe_orders, :separate_delivery_address, :boolean, :default => false
    add_column :shoppe_orders, :delivery_name, :string
    add_column :shoppe_orders, :delivery_address1, :string
    add_column :shoppe_orders, :delivery_address2, :string
    add_column :shoppe_orders, :delivery_address3, :string
    add_column :shoppe_orders, :delivery_address4, :string
    add_column :shoppe_orders, :deilvery_postcode, :string
    add_column :shoppe_orders, :delivery_country_id, :integer
  end
end