class CreateShoppeSettings < ActiveRecord::Migration
  def change
    create_table :shoppe_settings do |t|
      t.string :key, :value, :value_type
    end
  end
end
