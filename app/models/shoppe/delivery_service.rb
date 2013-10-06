# == Schema Information
#
# Table name: delivery_services
#
#  id           :integer          not null, primary key
#  name         :string(255)
#  code         :string(255)
#  default      :boolean          default(FALSE)
#  active       :boolean          default(TRUE)
#  created_at   :datetime
#  updated_at   :datetime
#  courier      :string(255)
#  tracking_url :string(255)
#

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
