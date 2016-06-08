class RenameTablesToShopr < ActiveRecord::Migration
  def change

    # Rename Shoppe tables to Shopr

    rename_table :shoppe_addresses, :shopr_addresses
    rename_table :shoppe_attachments, :shopr_attachments
    rename_table :shoppe_countries, :shopr_countries
    rename_table :shoppe_customers, :shopr_customers
    rename_table :shoppe_delivery_service_prices, :shopr_delivery_service_prices
    rename_table :shoppe_delivery_services, :shopr_delivery_services
    rename_table :shoppe_order_items, :shopr_order_items
    rename_table :shoppe_orders, :shopr_orders
    rename_table :shoppe_payments, :shopr_payments
    rename_table :shoppe_product_attributes, :shopr_product_attributes
    rename_table :shoppe_product_categories, :shopr_product_categories
    rename_table :shoppe_product_categorizations, :shopr_product_categorizations
    rename_table :shoppe_product_category_translations, :shopr_product_category_translations
    rename_table :shoppe_product_translations, :shopr_product_translations
    rename_table :shoppe_products, :shopr_products
    rename_table :shoppe_settings, :shopr_settings
    rename_table :shoppe_stock_level_adjustments, :shopr_stock_level_adjustments
    rename_table :shoppe_tax_rates, :shopr_tax_rates
    rename_table :shoppe_users, :shopr_users

  end
end
