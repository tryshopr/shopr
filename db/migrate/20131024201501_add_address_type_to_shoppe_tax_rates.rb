class AddAddressTypeToShoppeTaxRates < ActiveRecord::Migration
  def change
    add_column :shoppe_tax_rates, :address_type, :string
  end
end