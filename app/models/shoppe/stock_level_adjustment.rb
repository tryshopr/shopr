# == Schema Information
#
# Table name: shoppe_stock_level_adjustments
#
#  id          :integer          not null, primary key
#  item_id     :integer
#  item_type   :string(255)
#  description :string(255)
#  adjustment  :integer          default(0)
#  parent_type :string(255)
#  parent_id   :integer
#  created_at  :datetime
#  updated_at  :datetime
#

module Shoppe
  class StockLevelAdjustment < ActiveRecord::Base
    
    # Relationships
    belongs_to :item, :polymorphic => true
    belongs_to :parent, :polymorphic => true
    
    # Validations
    validates :description, :presence => true
    validates :adjustment, :numericality => true
    validate { errors.add(:adjustment, "must be greater or less than zero") if adjustment == 0 }
    
    # Scopes
    scope :ordered, -> { order('created_at desc') }
    
  end
end
