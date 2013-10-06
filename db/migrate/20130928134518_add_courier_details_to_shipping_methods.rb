class AddCourierDetailsToShippingMethods < ActiveRecord::Migration
  def change
    add_column :shoppe_delivery_services, :courier, :string
    add_column :shoppe_delivery_services, :tracking_url, :string
  end
end