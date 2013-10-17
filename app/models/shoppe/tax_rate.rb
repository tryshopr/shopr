module Shoppe
  class TaxRate < ActiveRecord::Base
    
    # Set the table name
    self.table_name = 'shoppe_tax_rates'
    
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
    
  end
end
