class AddIndexesToShoppeTaxRates < ActiveRecord::Migration
  def change
    add_index :shoppe_tax_rates, :country_ids
  end
end
