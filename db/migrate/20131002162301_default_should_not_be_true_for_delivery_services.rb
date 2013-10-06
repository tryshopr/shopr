class DefaultShouldNotBeTrueForDeliveryServices < ActiveRecord::Migration
  def change
    change_column_default :shoppe_delivery_services, :default, false
  end
end