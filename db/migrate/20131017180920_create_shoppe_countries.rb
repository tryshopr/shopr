class CreateShoppeCountries < ActiveRecord::Migration
  def up
    create_table :shoppe_countries do |t|
      t.string :name, :code2, :code3, :continent, :tld, :currency
      t.boolean :eu_member, :default => false
    end
    add_column :shoppe_orders, :country_id, :integer, :after => :postcode
    remove_column :shoppe_orders, :country
  end
  
  def down
    add_column :shoppe_orders, :country, :string, :after => :ip_address
    remove_column :shoppe_orders, :country_id
    drop_table :shoppe_countries
  end
end