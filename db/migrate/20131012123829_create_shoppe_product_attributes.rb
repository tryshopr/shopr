class CreateShoppeProductAttributes < ActiveRecord::Migration
  def change
    create_table :shoppe_product_attributes do |t|
      t.integer :product_id
      t.string :key, :value
      t.integer :position, :default => 1
      t.boolean :searchable, :default => true
      t.timestamps
    end
  end
end
