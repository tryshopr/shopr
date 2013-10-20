module Shoppe
  class TaxRate < ActiveRecord::Base
    
    # Set the table name
    self.table_name = 'shoppe_tax_rates'
    
    # Store countries as arrays
    serialize :country_ids, Array
    
    # Validations
    validates :name, :presence => true
    validates :rate, :numericality => true
    
    # Relationships
    has_many :products, :dependent => :restrict_with_exception
    has_many :delivery_service_prices, :dependent => :restrict_with_exception
    
    # Scopes
    scope :ordered, -> { order("shoppe_tax_rates.id")}
    
    # Ensure all country IDs are integers
    before_validation { self.country_ids = self.country_ids.map(&:to_i).select { |i| i > 0} if self.country_ids.is_a?(Array) }
    
    def description
      "#{name} (#{rate}%)"
    end
    
    def rate_for(order)
      self.rate
    end
    
  end
end
