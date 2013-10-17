class CreateShoppeTaxRates < ActiveRecord::Migration
  def up
    create_table :shoppe_tax_rates do |t|
      t.string :name
      t.decimal :rate, :precision => 8, :scale => 2
      t.timestamps
    end
    
    add_column :shoppe_products, :tax_rate_id, :integer, :after => :tax_rate
    remove_column :shoppe_products, :tax_rate

    add_column :shoppe_delivery_service_prices, :tax_rate_id, :integer, :after => :tax_rate
    remove_column :shoppe_delivery_service_prices, :tax_rate

  end
  
  def down
    add_column :shoppe_delivery_service_prices, :tax_rate, :decimal, :precision => 8, :scale => 2, :after => :price
    remove_column :shoppe_delivery_service_prices, :tax_rate_id

    add_column :shoppe_products, :tax_rate, :decimal, :precision => 8, :scale => 2, :after => :price
    remove_column :shoppe_products, :tax_rate_id
    
    drop_table :shoppe_tax_rates
  end
end