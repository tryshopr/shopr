# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160608183749) do

  create_table "nifty_key_value_store", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "parent_id"
    t.string   "parent_type"
    t.string   "group"
    t.string   "name"
    t.string   "value"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "shopr_addresses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "customer_id"
    t.string   "address_type"
    t.boolean  "default"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "address4"
    t.string   "postcode"
    t.integer  "country_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["customer_id"], name: "index_shopr_addresses_on_customer_id", using: :btree
  end

  create_table "shopr_attachments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "parent_id",   null: false
    t.string   "parent_type", null: false
    t.string   "token"
    t.string   "file"
    t.string   "file_name"
    t.integer  "file_size"
    t.string   "file_type"
    t.string   "role"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "shopr_countries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "code2"
    t.string   "code3"
    t.string   "continent"
    t.string   "tld"
    t.string   "currency"
    t.boolean  "eu_member",  default: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  create_table "shopr_customers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "email"
    t.string   "phone"
    t.string   "mobile"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "shopr_delivery_service_prices", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "delivery_service_id"
    t.string   "code"
    t.decimal  "price",                             precision: 8, scale: 2
    t.decimal  "cost_price",                        precision: 8, scale: 2
    t.integer  "tax_rate_id"
    t.decimal  "min_weight",                        precision: 8, scale: 2
    t.decimal  "max_weight",                        precision: 8, scale: 2
    t.text     "country_ids",         limit: 65535
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.index ["delivery_service_id"], name: "index_shopr_delivery_service_prices_on_delivery_service_id", using: :btree
    t.index ["max_weight"], name: "index_shopr_delivery_service_prices_on_max_weight", using: :btree
    t.index ["min_weight"], name: "index_shopr_delivery_service_prices_on_min_weight", using: :btree
    t.index ["price"], name: "index_shopr_delivery_service_prices_on_price", using: :btree
  end

  create_table "shopr_delivery_services", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "code"
    t.boolean  "default",      default: false
    t.boolean  "active",       default: true
    t.string   "courier"
    t.string   "tracking_url"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["active"], name: "index_shopr_delivery_services_on_active", using: :btree
  end

  create_table "shopr_order_items", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "order_id"
    t.integer  "ordered_item_id"
    t.string   "ordered_item_type"
    t.integer  "quantity",                                  default: 1
    t.decimal  "unit_price",        precision: 8, scale: 2
    t.decimal  "unit_cost_price",   precision: 8, scale: 2
    t.decimal  "tax_amount",        precision: 8, scale: 2
    t.decimal  "tax_rate",          precision: 8, scale: 2
    t.decimal  "weight",            precision: 8, scale: 3
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.index ["order_id"], name: "index_shopr_order_items_on_order_id", using: :btree
    t.index ["ordered_item_id", "ordered_item_type"], name: "index_shopr_order_items_ordered_item", using: :btree
  end

  create_table "shopr_orders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "company"
    t.string   "billing_address1"
    t.string   "billing_address2"
    t.string   "billing_address3"
    t.string   "billing_address4"
    t.string   "billing_postcode"
    t.integer  "billing_country_id"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "status"
    t.datetime "received_at"
    t.datetime "accepted_at"
    t.datetime "shipped_at"
    t.integer  "delivery_service_id"
    t.decimal  "delivery_price",                          precision: 8, scale: 2
    t.decimal  "delivery_cost_price",                     precision: 8, scale: 2
    t.decimal  "delivery_tax_rate",                       precision: 8, scale: 2
    t.decimal  "delivery_tax_amount",                     precision: 8, scale: 2
    t.integer  "accepted_by"
    t.integer  "shipped_by"
    t.string   "consignment_number"
    t.datetime "rejected_at"
    t.integer  "rejected_by"
    t.string   "ip_address"
    t.text     "notes",                     limit: 65535
    t.boolean  "separate_delivery_address",                                       default: false
    t.string   "delivery_name"
    t.string   "delivery_address1"
    t.string   "delivery_address2"
    t.string   "delivery_address3"
    t.string   "delivery_address4"
    t.string   "delivery_postcode"
    t.integer  "delivery_country_id"
    t.decimal  "amount_paid",                             precision: 8, scale: 2, default: "0.0"
    t.boolean  "exported",                                                        default: false
    t.string   "invoice_number"
    t.integer  "customer_id"
    t.datetime "created_at",                                                                      null: false
    t.datetime "updated_at",                                                                      null: false
    t.index ["delivery_service_id"], name: "index_shopr_orders_on_delivery_service_id", using: :btree
    t.index ["received_at"], name: "index_shopr_orders_on_received_at", using: :btree
    t.index ["token"], name: "index_shopr_orders_on_token", using: :btree
  end

  create_table "shopr_payments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "order_id"
    t.decimal  "amount",            precision: 8, scale: 2, default: "0.0"
    t.string   "reference"
    t.string   "method"
    t.boolean  "confirmed",                                 default: true
    t.boolean  "refundable",                                default: false
    t.decimal  "amount_refunded",   precision: 8, scale: 2, default: "0.0"
    t.integer  "parent_payment_id"
    t.boolean  "exported",                                  default: false
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.index ["order_id"], name: "index_shopr_payments_on_order_id", using: :btree
    t.index ["parent_payment_id"], name: "index_shopr_payments_on_parent_payment_id", using: :btree
  end

  create_table "shopr_product_attributes", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "product_id"
    t.string   "key"
    t.string   "value"
    t.integer  "position",   default: 1
    t.boolean  "searchable", default: true
    t.boolean  "public",     default: true
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.index ["key"], name: "index_shopr_product_attributes_on_key", using: :btree
    t.index ["position"], name: "index_shopr_product_attributes_on_position", using: :btree
    t.index ["product_id"], name: "index_shopr_product_attributes_on_product_id", using: :btree
  end

  create_table "shopr_product_categories", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "permalink"
    t.text     "description",                  limit: 65535
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.integer  "depth"
    t.string   "ancestral_permalink"
    t.boolean  "permalink_includes_ancestors",               default: false
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.index ["lft"], name: "index_shopr_product_categories_on_lft", using: :btree
    t.index ["permalink"], name: "index_shopr_product_categories_on_permalink", using: :btree
    t.index ["rgt"], name: "index_shopr_product_categories_on_rgt", using: :btree
  end

  create_table "shopr_product_categorizations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "product_id",          null: false
    t.integer "product_category_id", null: false
    t.index ["product_category_id"], name: "categorization_by_product_category_id", using: :btree
    t.index ["product_id"], name: "categorization_by_product_id", using: :btree
  end

  create_table "shopr_products", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.string   "sku"
    t.string   "permalink"
    t.text     "description",       limit: 65535
    t.text     "short_description", limit: 65535
    t.boolean  "active",                                                  default: true
    t.decimal  "weight",                          precision: 8, scale: 3, default: "0.0"
    t.decimal  "price",                           precision: 8, scale: 2, default: "0.0"
    t.decimal  "cost_price",                      precision: 8, scale: 2, default: "0.0"
    t.integer  "tax_rate_id"
    t.boolean  "featured",                                                default: false
    t.text     "in_the_box",        limit: 65535
    t.boolean  "stock_control",                                           default: true
    t.boolean  "default",                                                 default: false
    t.datetime "created_at",                                                              null: false
    t.datetime "updated_at",                                                              null: false
    t.index ["parent_id"], name: "index_shopr_products_on_parent_id", using: :btree
    t.index ["permalink"], name: "index_shopr_products_on_permalink", using: :btree
    t.index ["sku"], name: "index_shopr_products_on_sku", using: :btree
  end

  create_table "shopr_settings", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "key"
    t.string "value"
    t.string "value_type"
    t.index ["key"], name: "index_shopr_settings_on_key", using: :btree
  end

  create_table "shopr_stock_level_adjustments", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "item_id"
    t.string   "item_type"
    t.string   "description"
    t.integer  "adjustment",  default: 0
    t.string   "parent_type"
    t.integer  "parent_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.index ["item_id", "item_type"], name: "index_shopr_stock_level_adjustments_items", using: :btree
    t.index ["parent_id", "parent_type"], name: "index_shopr_stock_level_adjustments_parent", using: :btree
  end

  create_table "shopr_tax_rates", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.decimal  "rate",                       precision: 8, scale: 2
    t.text     "country_ids",  limit: 65535
    t.string   "address_type"
    t.datetime "created_at",                                         null: false
    t.datetime "updated_at",                                         null: false
  end

  create_table "shopr_users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.index ["email_address"], name: "index_shopr_users_on_email_address", using: :btree
  end

end
