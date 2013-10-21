module Shoppe
  class TaxRate < ActiveRecord::Base
    
    # Set the table name
    self.table_name = 'shoppe_tax_rates'
    
    # Tax rates are associated with countries
    include Shoppe::AssociatedCountries
    
    # Validations
    validates :name, :presence => true
    validates :rate, :numericality => true
    
    # Relationships
    has_many :products, :dependent => :restrict_with_exception
    has_many :delivery_service_prices, :dependent => :restrict_with_exception
    
    # Scopes
    scope :ordered, -> { order("shoppe_tax_rates.id")}
    
    def description
      "#{name} (#{rate}%)"
    end
    
    def rate_for(order)
      if countries.empty? || order.country.nil? || country?(order.country)
        self.rate
      else
        0.0
      end
    end
    
  end
end
