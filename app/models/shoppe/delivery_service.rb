class Shoppe::DeliveryService < ActiveRecord::Base
  
  self.table_name = 'shoppe_delivery_services'
  
  validates :name, :presence => true
  validates :courier, :presence => true
  
  has_many :orders, :dependent => :restrict_with_exception
  has_many :delivery_service_prices, :dependent => :destroy
  
  scope :active, -> { where(:active => true)}
  
  def tracking_url_for(consignment_number)
    tracking_url.gsub("{{consignment_number}}", consignment_number)
  end
  
end
