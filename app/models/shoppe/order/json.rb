module Shoppe
  class Order < ActiveRecord::Base
    
    # Attributes
    json :number
    json :first_name, :last_name, :full_name, :company, :email_address, :phone_number
    json :status, :received_at, :accepted_at, :rejected_at, :shipped_at
    json :delivery_service, :consignment_number, :delivery_name, :total_weight
    json :delivery_price, :delivery_cost_price, :delivery_tax_rate, :delivery_tax_amount
    json :ip_address
    json :exported, :invoice_number
    
    with_options :group => :delivery_address, :if => proc { |o| o.separate_delivery_address? } do |o|
      o.json :delivery_address1, :as => :line1
      o.json :delivery_address2, :as => :line2
      o.json :delivery_address3, :as => :line3
      o.json :delivery_address4, :as => :line4
      o.json :delivery_postcode, :as => :postcode
      o.json :delivery_country, :as => :country
    end
    
    with_options :group => :billing_address do |o|
      o.json :billing_address1, :as => :line1
      o.json :billing_address2, :as => :line2
      o.json :billing_address3, :as => :line3
      o.json :billing_address4, :as => :line4
      o.json :billing_postcode, :as => :postcode
      o.json :billing_country, :as => :country
    end
    
    # Methods
    json :build_time, :total_items, :has_items?
    
    with_options :group => :money do |o|
      o.json :total_before_tax, :tax, :total, :balance, :amount_paid, :total_cost, :profit
    end
    
    # Relationships
    json :order_items
    
  end
end
