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
