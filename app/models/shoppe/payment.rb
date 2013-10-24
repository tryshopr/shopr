# == Schema Information
#
# Table name: shoppe_payments
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  amount     :decimal(8, 2)
#  reference  :string(255)
#  method     :string(255)
#  exported   :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

module Shoppe
  class Payment < ActiveRecord::Base
    
    # Relationships
    belongs_to :order, :class_name => 'Shoppe::Order'
    
    # Validations
    validates :amount, :numericality => true
    validates :reference, :presence => true
    validates :method, :presence => true
    
    # Properties can be assigned to a payment which may be useful
    key_value_store :properties
    
  end
end
