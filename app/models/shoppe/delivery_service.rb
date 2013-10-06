class Shoppe::DeliveryService < ActiveRecord::Base
  
  # Set the table name
  self.table_name = 'shoppe_delivery_services'
  
  # Validations
  validates :name, :presence => true
  validates :courier, :presence => true
  
  # Relationships
  has_many :orders, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Order'
  has_many :delivery_service_prices, :dependent => :destroy, :class_name => 'Shoppe::DeliveryServicePrice'
  
  # Scopes
  scope :active, -> { where(:active => true)}
  
  # Return the tracking URL for the given consignment number
  def tracking_url_for(consignment_number)
    tracking_url.gsub("{{consignment_number}}", consignment_number)
  end
  
end
