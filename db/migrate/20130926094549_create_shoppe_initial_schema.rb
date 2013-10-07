class CreateShoppeInitialSchema < ActiveRecord::Migration
  def up
    create_table "shoppe_delivery_service_prices", force: true do |t|
      t.integer  "delivery_service_id"
      t.string   "code"
      t.decimal  "price",               precision: 8, scale: 2
      t.decimal  "tax_rate",            precision: 8, scale: 2
      t.decimal  "min_weight",          precision: 8, scale: 2
      t.decimal  "max_weight",          precision: 8, scale: 2
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "shoppe_delivery_services", force: true do |t|
      t.string   "name"
      t.string   "code"
      t.boolean  "default",      default: false
      t.boolean  "active",       default: true
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "courier"
      t.string   "tracking_url"
    end

    create_table "shoppe_order_items", force: true do |t|
      t.integer  "order_id"
      t.integer  "product_id"
      t.integer  "quantity",                           default: 1
      t.decimal  "unit_price", precision: 8, scale: 2
      t.decimal  "tax_amount", precision: 8, scale: 2
      t.decimal  "tax_rate",   precision: 8, scale: 2
      t.decimal  "weight",     precision: 8, scale: 3, default: 0.0
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "shoppe_orders", force: true do |t|
      t.string   "token"
      t.string   "first_name"
      t.string   "last_name"
      t.string   "company"
      t.string   "address1"
      t.string   "address2"
      t.string   "address3"
      t.string   "address4"
      t.string   "postcode"
      t.string   "email_address"
      t.string   "phone_number"
      t.string   "status"
      t.datetime "received_at"
      t.datetime "accepted_at"
      t.datetime "shipped_at"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "delivery_service_id"
      t.decimal  "delivery_price",      precision: 8, scale: 2
      t.decimal  "delivery_tax_rate",   precision: 8, scale: 2
      t.decimal  "delivery_tax_amount", precision: 8, scale: 2
      t.datetime "paid_at"
      t.integer  "accepted_by"
      t.integer  "shipped_by"
      t.string   "consignment_number"
      t.datetime "rejected_at"
      t.integer  "rejected_by"
      t.string   "ip_address"
      t.string   "country"
      t.string   "payment_reference"
      t.string   "payment_method"
    end

    create_table "shoppe_product_categories", force: true do |t|
      t.string   "name"
      t.string   "permalink"
      t.text     "description"
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    create_table "shoppe_products", force: true do |t|
      t.integer  "product_category_id"
      t.string   "title"
      t.string   "sku"
      t.string   "permalink"
      t.text     "description"
      t.text     "short_description"
      t.boolean  "active",                                      default: true
      t.decimal  "weight",              precision: 8, scale: 3, default: 0.0
      t.decimal  "price",               precision: 8, scale: 2, default: 0.0
      t.decimal  "tax_rate",            precision: 8, scale: 2, default: 0.0
      t.integer  "stock",                                       default: 0
      t.datetime "created_at"
      t.datetime "updated_at"
      t.boolean  "featured",                                    default: false
      t.text     "in_the_box"
    end

    create_table "shoppe_users", force: true do |t|
      t.string   "first_name"
      t.string   "last_name"
      t.string   "email_address"
      t.string   "password_digest"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
  
  def down
    drop_table :shoppe_delivery_service_prices
    drop_table :shoppe_delivery_services
    drop_table :shoppe_order_items
    drop_table :shoppe_orders
    drop_table :shoppe_product_categories
    drop_table :shoppe_products
    drop_table :shoppe_users
  end
end
