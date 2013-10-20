class AddCountriesToTaxRatesAndDeliveryPrices < ActiveRecord::Migration
  def change
    add_column :shoppe_delivery_service_prices, :country_ids, :text
    add_column :shoppe_tax_rates, :country_ids, :text
  end
end