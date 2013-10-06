class AddCountryToOrders < ActiveRecord::Migration
  def change
    add_column :shoppe_orders, :country, :string, :after => :postcode
  end
end