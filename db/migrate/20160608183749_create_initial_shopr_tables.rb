class CreateInitialShoprTables < ActiveRecord::Migration[4.2]

  create_table 'nifty_key_value_store' do |t|
    t.integer :parent_id
    t.string  :parent_type
    t.string  :group
    t.string  :name
    t.string  :value
    t.timestamps
  end

  create_table 'shopr_addresses' do |t|
    t.integer :customer_id
    t.string  :address_type
    t.boolean :default
    t.string  :address1
    t.string  :address2
    t.string  :address3
    t.string  :address4
    t.string  :postcode
    t.integer :country_id
    t.timestamps
  end

  add_index 'shopr_addresses', ['customer_id'], name: 'index_shopr_addresses_on_customer_id'

  create_table 'shopr_attachments' do |t|
    t.integer  :parent_id,   null: false
    t.string   :parent_type, null: false
    t.string   :token
    t.string   :file
    t.string   :file_name
    t.integer  :file_size
    t.string   :file_type
    t.string   :role
    t.timestamps
  end

  create_table 'shopr_countries' do |t|
    t.string  :name
    t.string  :code2
    t.string  :code3
    t.string  :continent
    t.string  :tld
    t.string  :currency
    t.boolean :eu_member, default: false
    t.timestamps
  end

  create_table 'shopr_customers' do |t|
    t.string :first_name
    t.string :last_name
    t.string :company
    t.string :email
    t.string :phone
    t.string :mobile
    t.timestamps
  end

  create_table 'shopr_delivery_service_prices' do |t|
    t.integer :delivery_service_id
    t.string  :code
    t.decimal :price,               precision: 8, scale: 2
    t.decimal :cost_price,          precision: 8, scale: 2
    t.integer :tax_rate_id
    t.decimal :min_weight,          precision: 8, scale: 2
    t.decimal :max_weight,          precision: 8, scale: 2
    t.text    :country_ids
    t.timestamps
  end

  add_index 'shopr_delivery_service_prices', ['delivery_service_id'], name: 'index_shopr_delivery_service_prices_on_delivery_service_id'
  add_index 'shopr_delivery_service_prices', ['max_weight'], name: 'index_shopr_delivery_service_prices_on_max_weight'
  add_index 'shopr_delivery_service_prices', ['min_weight'], name: 'index_shopr_delivery_service_prices_on_min_weight'
  add_index 'shopr_delivery_service_prices', ['price'], name: 'index_shopr_delivery_service_prices_on_price'

  create_table 'shopr_delivery_services' do |t|
    t.string  :name
    t.string  :code
    t.boolean :default,      default: false
    t.boolean :active,       default: true
    t.string  :courier
    t.string  :tracking_url
    t.timestamps
  end

  add_index 'shopr_delivery_services', ['active'], name: 'index_shopr_delivery_services_on_active'

  create_table 'shopr_order_items' do |t|
    t.integer :order_id
    t.integer :ordered_item_id
    t.string  :ordered_item_type
    t.integer :quantity, default: 1
    t.decimal :unit_price,        precision: 8, scale: 2
    t.decimal :unit_cost_price,   precision: 8, scale: 2
    t.decimal :tax_amount,        precision: 8, scale: 2
    t.decimal :tax_rate,          precision: 8, scale: 2
    t.decimal :weight,            precision: 8, scale: 3
    t.timestamps
  end

  add_index 'shopr_order_items', ['order_id'], name: 'index_shopr_order_items_on_order_id'
  add_index 'shopr_order_items', %w(ordered_item_id ordered_item_type), name: 'index_shopr_order_items_ordered_item'

  create_table 'shopr_orders' do |t|
    t.string   :token
    t.string   :first_name
    t.string   :last_name
    t.string   :company
    t.string   :billing_address1
    t.string   :billing_address2
    t.string   :billing_address3
    t.string   :billing_address4
    t.string   :billing_postcode
    t.integer  :billing_country_id
    t.string   :email_address
    t.string   :phone_number
    t.string   :status
    t.datetime :received_at
    t.datetime :accepted_at
    t.datetime :shipped_at
    t.integer  :delivery_service_id
    t.decimal  :delivery_price,            precision: 8, scale: 2
    t.decimal  :delivery_cost_price,       precision: 8, scale: 2
    t.decimal  :delivery_tax_rate,         precision: 8, scale: 2
    t.decimal  :delivery_tax_amount,       precision: 8, scale: 2
    t.integer  :accepted_by
    t.integer  :shipped_by
    t.string   :consignment_number
    t.datetime :rejected_at
    t.integer  :rejected_by
    t.string   :ip_address
    t.text     :notes
    t.boolean  :separate_delivery_address, default: false
    t.string   :delivery_name
    t.string   :delivery_address1
    t.string   :delivery_address2
    t.string   :delivery_address3
    t.string   :delivery_address4
    t.string   :delivery_postcode
    t.integer  :delivery_country_id
    t.decimal  :amount_paid, precision: 8, scale: 2, default: 0.0
    t.boolean  :exported, default: false
    t.string   :invoice_number
    t.integer  :customer_id
    t.timestamps
  end

  add_index 'shopr_orders', ['delivery_service_id'], name: 'index_shopr_orders_on_delivery_service_id'
  add_index 'shopr_orders', ['received_at'], name: 'index_shopr_orders_on_received_at'
  add_index 'shopr_orders', ['token'], name: 'index_shopr_orders_on_token'

  create_table 'shopr_payments' do |t|
    t.integer :order_id
    t.decimal :amount, precision: 8, scale: 2, default: 0.0
    t.string  :reference
    t.string  :method
    t.boolean :confirmed,                                 default: true
    t.boolean :refundable,                                default: false
    t.decimal :amount_refunded, precision: 8, scale: 2, default: 0.0
    t.integer :parent_payment_id
    t.boolean :exported, default: false
    t.timestamps
  end

  add_index 'shopr_payments', ['order_id'], name: 'index_shopr_payments_on_order_id'
  add_index 'shopr_payments', ['parent_payment_id'], name: 'index_shopr_payments_on_parent_payment_id'

  create_table 'shopr_product_attributes' do |t|
    t.integer :product_id
    t.string  :key
    t.string  :value
    t.integer :position,   default: 1
    t.boolean :searchable, default: true
    t.boolean :public, default: true
    t.timestamps
  end

  add_index 'shopr_product_attributes', ['key'], name: 'index_shopr_product_attributes_on_key'
  add_index 'shopr_product_attributes', ['position'], name: 'index_shopr_product_attributes_on_position'
  add_index 'shopr_product_attributes', ['product_id'], name: 'index_shopr_product_attributes_on_product_id'

  create_table 'shopr_product_categories' do |t|
    t.string  :name
    t.string  :permalink
    t.text    :description
    t.integer :parent_id
    t.integer :lft
    t.integer :rgt
    t.integer :depth
    t.string  :ancestral_permalink
    t.boolean :permalink_includes_ancestors, default: false
    t.timestamps
  end

  add_index 'shopr_product_categories', ['lft'], name: 'index_shopr_product_categories_on_lft'
  add_index 'shopr_product_categories', ['permalink'], name: 'index_shopr_product_categories_on_permalink'
  add_index 'shopr_product_categories', ['rgt'], name: 'index_shopr_product_categories_on_rgt'

  create_table 'shopr_product_categorizations' do |t|
    t.integer :product_id,          null: false
    t.integer :product_category_id, null: false
  end

  add_index 'shopr_product_categorizations', ['product_category_id'], name: 'categorization_by_product_category_id'
  add_index 'shopr_product_categorizations', ['product_id'], name: 'categorization_by_product_id'

  create_table 'shopr_products' do |t|
    t.integer :parent_id
    t.string  :name
    t.string  :sku
    t.string  :permalink
    t.text    :description
    t.text    :short_description
    t.boolean :active,                                    default: true
    t.decimal :weight,            precision: 8, scale: 3, default: 0.0
    t.decimal :price,             precision: 8, scale: 2, default: 0.0
    t.decimal :cost_price,        precision: 8, scale: 2, default: 0.0
    t.integer :tax_rate_id
    t.boolean :featured, default: false
    t.text    :in_the_box
    t.boolean :stock_control,                             default: true
    t.boolean :default,                                   default: false
    t.timestamps
  end

  add_index 'shopr_products', ['parent_id'], name: 'index_shopr_products_on_parent_id'
  add_index 'shopr_products', ['permalink'], name: 'index_shopr_products_on_permalink'
  add_index 'shopr_products', ['sku'], name: 'index_shopr_products_on_sku'

  create_table 'shopr_settings' do |t|
    t.string :key
    t.string :value
    t.string :value_type
  end

  add_index 'shopr_settings', ['key'], name: 'index_shopr_settings_on_key'

  create_table 'shopr_stock_level_adjustments' do |t|
    t.integer :item_id
    t.string  :item_type
    t.string  :description
    t.integer :adjustment, default: 0
    t.string  :parent_type
    t.integer :parent_id
    t.timestamps
  end

  add_index 'shopr_stock_level_adjustments', %w(item_id item_type), name: 'index_shopr_stock_level_adjustments_items'
  add_index 'shopr_stock_level_adjustments', %w(parent_id parent_type), name: 'index_shopr_stock_level_adjustments_parent'

  create_table 'shopr_tax_rates' do |t|
    t.string  :name
    t.decimal :rate, precision: 8, scale: 2
    t.text    :country_ids
    t.string  :address_type
    t.timestamps
  end

  create_table :shopr_users do |t|
    ## Database authenticatable
    t.string :email,              null: false, default: ""
    t.string :encrypted_password, null: false, default: ""

    ## Recoverable
    t.string   :reset_password_token
    t.datetime :reset_password_sent_at

    ## Rememberable
    t.datetime :remember_created_at

    ## Trackable
    t.integer  :sign_in_count, default: 0, null: false
    t.datetime :current_sign_in_at
    t.datetime :last_sign_in_at
    t.string   :current_sign_in_ip
    t.string   :last_sign_in_ip

    t.string :first_name
    t.string :last_name

    t.timestamps null: false
  end

  add_index :shopr_users, :email,                unique: true
  add_index :shopr_users, :reset_password_token, unique: true

end
