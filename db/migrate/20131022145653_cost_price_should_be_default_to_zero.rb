class CostPriceShouldBeDefaultToZero < ActiveRecord::Migration
  def up
    change_column_default :shoppe_products, :cost_price, 0.0
  end
  
  def down
    change_column_default :shoppe_products, :cost_price, nil
  end
end