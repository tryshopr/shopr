class CreateDeliveryServices < ActiveRecord::Migration
  def change
    create_table :shoppe_delivery_services do |t|
      t.string :name, :code
      t.boolean :default, :default => true
      t.decimal :min_weight, :precision => 8, :scale => 3
      t.decimal :max_weight, :precision => 8, :scale => 3
      t.decimal :price, :default => 0, :precision => 8, :scale => 2
      t.decimal :vat_rate, :precision => 8, :scale => 2
      t.boolean :active, :default => true
      t.timestamps
    end
  end
end
