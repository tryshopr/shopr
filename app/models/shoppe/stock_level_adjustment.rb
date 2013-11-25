module Shoppe
  class StockLevelAdjustment < ActiveRecord::Base
    
    # The orderable item which the stock level adjustment belongs to
    belongs_to :item, :polymorphic => true
    
    # The parent (OrderItem) which the stock level adjustment belongs to
    belongs_to :parent, :polymorphic => true
    
    # Validations
    validates :description, :presence => true
    validates :adjustment, :numericality => true
    validate { errors.add(:adjustment, "must be greater or less than zero") if adjustment == 0 }
    
    # All stock level adjustments ordered by their created date desending
    scope :ordered, -> { order(:id => :desc) }
    
  end
end
