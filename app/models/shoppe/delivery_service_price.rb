class Shoppe::DeliveryServicePrice < ActiveRecord::Base

  # Set the table name
  self.table_name = 'shoppe_delivery_service_prices'
  
  # Store countries as arrays
  serialize :country_ids, Array
  
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
  
  # Ensure all country IDs are integers
  before_validation { self.country_ids = self.country_ids.map(&:to_i).select { |i| i > 0} if self.country_ids.is_a?(Array) }
  
end
