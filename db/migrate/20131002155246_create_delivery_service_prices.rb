class CreateDeliveryServicePrices < ActiveRecord::Migration
  def change
    create_table :shoppe_delivery_service_prices do |t|
      t.integer :delivery_service_id
      t.string :code
      t.decimal :price, :precision => 8, :scale => 2
      t.decimal :tax_rate, :precision => 8, :scale => 2
      t.decimal :min_weight, :precision => 8, :scale => 2
      t.decimal :max_weight, :precision => 8, :scale => 2
      t.timestamps
    end
    remove_column :shoppe_delivery_services, :price
    remove_column :shoppe_delivery_services, :tax_rate
    remove_column :shoppe_delivery_services, :min_weight
    remove_column :shoppe_delivery_services, :max_weight
  end
end
