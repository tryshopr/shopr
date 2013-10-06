# == Schema Information
#
# Table name: delivery_service_prices
#
#  id                  :integer          not null, primary key
#  delivery_service_id :integer
#  code                :string(255)
#  price               :decimal(8, 2)
#  tax_rate            :decimal(8, 2)
#  min_weight          :decimal(8, 2)
#  max_weight          :decimal(8, 2)
#  created_at          :datetime
#  updated_at          :datetime
#

class Shoppe::DeliveryServicePrice < ActiveRecord::Base
  
  belongs_to :delivery_service
  
  validates :price, :numericality => true
  validates :tax_rate, :numericality => true
  validates :min_weight, :numericality => true
  validates :max_weight, :numericality => true
  
  scope :ordered, -> { order('price asc')}
  scope :for_weight, -> weight { where("min_weight <= ? AND max_weight >= ?", weight, weight) }
  
end
