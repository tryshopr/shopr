module Shoppe
  class StockLevelAdjustment < ActiveRecord::Base
    
    # Relationships
    belongs_to :product, :class_name => 'Shoppe::Product'
    belongs_to :parent, :polymorphic => true
    
    # Validations
    validates :product_id, :presence => true
    validates :description, :presence => true
    validates :adjustment, :numericality => true
    validate { errors.add(:adjustment, "must be greater or less than zero") if adjustment == 0 }
    
    # Scopes
    scope :ordered, -> { order('created_at desc') }
    
  end
end
