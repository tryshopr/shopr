# == Schema Information
#
# Table name: shoppe_delivery_service_prices
#
#  id                  :integer          not null, primary key
#  delivery_service_id :integer
#  code                :string(255)
#  price               :decimal(8, 2)
#  cost_price          :decimal(8, 2)
#  tax_rate_id         :integer
#  min_weight          :decimal(8, 2)
#  max_weight          :decimal(8, 2)
#  created_at          :datetime
#  updated_at          :datetime
#  country_ids         :text
#

module Shoppe
  class DeliveryServicePrice < ActiveRecord::Base

    # Set the table name
    self.table_name = 'shoppe_delivery_service_prices'
  
    # Tax rates are associated with countries
    include Shoppe::AssociatedCountries
  
    # Relationships
    belongs_to :delivery_service, :class_name => 'Shoppe::DeliveryService'
    belongs_to :tax_rate, :class_name => "Shoppe::TaxRate"
  
    # Validations
    validates :price, :numericality => true
    validates :cost_price, :numericality => true, :allow_blank => true
    validates :min_weight, :numericality => true
    validates :max_weight, :numericality => true
  
    # Scopes
    scope :ordered, -> { order('price asc')}
    scope :for_weight, -> weight { where("min_weight <= ? AND max_weight >= ?", weight, weight) }
  
  end
end
