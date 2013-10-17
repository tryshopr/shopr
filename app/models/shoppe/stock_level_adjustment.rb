module Shoppe
  class StockLevelAdjustment < ActiveRecord::Base
    
    # Relationships
    belongs_to :product
    belongs_to :parent, :polymorphic => true
    
    # Validations
    validates :product_id, :presence => true
    validates :adjustment, :numericality => true
    
    # Scopes
    scope :ordered, -> { order('created_at desc') }
    
  end
end
