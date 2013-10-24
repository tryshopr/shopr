# == Schema Information
#
# Table name: shoppe_tax_rates
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  rate         :decimal(8, 2)
#  created_at   :datetime
#  updated_at   :datetime
#  country_ids  :text
#  address_type :string(255)
#

module Shoppe
  class TaxRate < ActiveRecord::Base
    
    # Set the table name
    self.table_name = 'shoppe_tax_rates'
    
    # Tax rates are associated with countries
    include Shoppe::AssociatedCountries
    
    # The order addresses which may be 
    ADDRESS_TYPES = ['billing', 'delivery']
    
    # Validations
    validates :name, :presence => true
    validates :address_type, :inclusion => {:in => ADDRESS_TYPES}
    validates :rate, :numericality => true
    
    # Relationships
    has_many :products, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Product'
    has_many :delivery_service_prices, :dependent => :restrict_with_exception, :class_name => 'Shoppe::DeliveryServicePrice'
    
    # Scopes
    scope :ordered, -> { order("shoppe_tax_rates.id")}
    
    def description
      "#{name} (#{rate}%)"
    end
    
    def rate_for(order)
      return rate if countries.empty?
      return rate if address_type == 'billing'  && (order.billing_country.nil?   || country?(order.billing_country))
      return rate if address_type == 'delivery' && (order.delivery_country.nil?  || country?(order.delivery_country))
      0.0
    end
    
  end
end
