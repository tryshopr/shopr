# == Schema Information
#
# Table name: shoppe_orders
#
#  id                        :integer          not null, primary key
#  token                     :string(255)
#  first_name                :string(255)
#  last_name                 :string(255)
#  company                   :string(255)
#  billing_address1          :string(255)
#  billing_address2          :string(255)
#  billing_address3          :string(255)
#  billing_address4          :string(255)
#  billing_postcode          :string(255)
#  billing_country_id        :integer
#  email_address             :string(255)
#  phone_number              :string(255)
#  status                    :string(255)
#  received_at               :datetime
#  accepted_at               :datetime
#  shipped_at                :datetime
#  created_at                :datetime
#  updated_at                :datetime
#  delivery_service_id       :integer
#  delivery_price            :decimal(8, 2)
#  delivery_cost_price       :decimal(8, 2)
#  delivery_tax_rate         :decimal(8, 2)
#  delivery_tax_amount       :decimal(8, 2)
#  accepted_by               :integer
#  shipped_by                :integer
#  consignment_number        :string(255)
#  rejected_at               :datetime
#  rejected_by               :integer
#  ip_address                :string(255)
#  notes                     :text
#  separate_delivery_address :boolean          default(FALSE)
#  delivery_name             :string(255)
#  delivery_address1         :string(255)
#  delivery_address2         :string(255)
#  delivery_address3         :string(255)
#  delivery_address4         :string(255)
#  deilvery_postcode         :string(255)
#  delivery_country_id       :integer
#  amount_paid               :decimal(8, 2)    default(0.0)
#  exported                  :boolean          default(FALSE)
#  invoice_number            :string(255)
#

module Shoppe
  class Order < ActiveRecord::Base

    self.table_name = 'shoppe_orders'
  
    # Orders can have properties
    key_value_store :properties
    
    # Require dependencies
    require_dependency 'shoppe/order/states'
    require_dependency 'shoppe/order/actions'
    require_dependency 'shoppe/order/billing'
    require_dependency 'shoppe/order/delivery'
  
    # All items which make up this order
    has_many :order_items, :dependent => :destroy, :class_name => 'Shoppe::OrderItem'

    # All products which are part of this order (accessed through the items)
    has_many :products, :through => :order_items, :class_name => 'Shoppe::Product'
    
    # Validations
    validates :token, :presence => true
    with_options :if => Proc.new { |o| !o.building? } do |order|
      order.validates :email_address, :format => {:with => /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i}
      order.validates :phone_number, :format => {:with => /\A[\d\ \-x\(\)]{7,}\z/}
    end
  
    # Set some defaults
    before_validation { self.token = SecureRandom.uuid  if self.token.blank? }
    
    # The order number
    #
    # @return [String] - the order number padded with at least 5 zeros
    def number
      id.to_s.rjust(6, '0')
    end
  
    # The length of time the customer spent building the order before submitting it to us.
    # The time from first item in basket to received.
    #
    # @return [Float] - the length of time
    def build_time
      return nil if self.received_at.blank?
      self.created_at - self.received_at
    end
  
    # The name of the customer in the format of "Company (First Last)" or if they don't have
    # company specified, just "First Last".
    #
    # @return [String]
    def customer_name
      company.blank? ? full_name : "#{company} (#{full_name})"
    end
    
    # The full name of the customer created by concatinting the first & last name
    #
    # @return [String]
    def full_name
      "#{first_name} #{last_name}"
    end
  
    # Is this order empty? (i.e. doesn't have any items associated with it)
    #
    # @return [Boolean]
    def empty?
      order_items.empty?
    end
  
    # Does this order have items?
    #
    # @return [Boolean]
    def has_items?
      total_items > 0
    end
  
    # Return the number of items in the order?
    #
    # @return [Integer]
    def total_items
      @total_items ||= order_items.inject(0) { |t,i| t + i.quantity }
    end
    
    def self.ransackable_attributes(auth_object = nil) 
      ["id", "billing_postcode", "billing_address1", "billing_address2", "billing_address3", "billing_address4", "first_name", "last_name", "company", "email_address", "phone_number", "consignment_number", "status", "received_at"] + _ransackers.keys
    end
  
    def self.ransackable_associations(auth_object = nil)
      ['products']
    end
  
  end
end
