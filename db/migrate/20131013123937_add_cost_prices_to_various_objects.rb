class AddCostPricesToVariousObjects < ActiveRecord::Migration
  def change
    add_column :shoppe_products, :cost_price, :decimal, :precision => 8, :scale => 2, :after => :price
    add_column :shoppe_delivery_service_prices, :cost_price, :decimal, :precision => 8, :scale => 2, :after => :price
    add_column :shoppe_order_items, :unit_cost_price, :decimal, :precision => 8, :scale => 2, :after => :unit_price
    add_column :shoppe_orders, :delivery_cost_price, :decimal, :precision => 8, :scale => 2, :after => :delivery_price
  end
end