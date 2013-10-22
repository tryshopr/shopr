module Shoppe
  # All items which can be ordered should include this module and ensure that all methods
  # have been overridden. It's a lazy-mans protocol.
  module OrderableItem
    
    # stock_level_adjustments must be an association
    
    def full_name
    end
    
    def orderable?
    end
    
    def sku
    end
    
    def price
    end
    
    def cost_price
    end
    
    def tax_rate
    end
    
    def stock_control?
    end
    
    def in_stock?
    end
    
    def stock
    end
    
    def weight
    end
    
  end
end
