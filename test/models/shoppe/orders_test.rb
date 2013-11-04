require 'test_helper'

module Shoppe
  class OrdersTest < ActiveSupport::TestCase
    
    test "a completely clean new order" do
      order = create(:order)
      assert_equal true, order.building?
      assert_equal false, order.received?
      assert_equal true, order.empty?
      assert_equal 0, order.total_items
      assert_equal false, order.has_items?
      assert_match /\A\d{6}\z/, order.number
      assert_match /\A[a-f0-9\-]{36}\z/, order.token
      
      assert_equal 0.0, order.total_cost
      assert_equal 0.0, order.profit
      assert_equal 0.0, order.total_before_tax
      assert_equal 0.0, order.tax
      assert_equal 0.0, order.total
      assert_equal 0.0, order.balance
      
      assert_equal false, order.payment_outstanding?
      assert_equal true, order.paid_in_full?
      assert_equal false, order.invoiced?
      
      assert_equal false, order.delivery_required?
      assert_equal nil, order.delivery_service
      assert_equal false, order.shipped?
      assert_equal 0.0, order.total_weight
      assert_equal [], order.available_delivery_services
      assert_equal [], order.delivery_service_prices
      assert_equal nil, order.delivery_service_price
      assert_equal 0.0, order.delivery_price
      assert_equal 0.0, order.delivery_cost_price
      assert_equal 0.0, order.delivery_tax_amount
      assert_equal 0.0, order.delivery_tax_rate
      assert_equal true, order.valid_delivery_service?
      assert_equal nil, order.courier_tracking_url
    end
    
    test "order string generation (for an order without a company)" do
      order = create(:order)
      assert_equal "Joe Bloggs", order.full_name
      assert_equal "Joe Bloggs", order.customer_name
      assert_equal "Joe Bloggs", order.billing_name
      assert_equal "Joe Bloggs", order.delivery_name
    end
    
    test "order string generation (for an order with a company)" do
      order = create(:order, :company => "Widgets Inc")
      assert_equal "Joe Bloggs", order.full_name
      assert_equal "Widgets Inc (Joe Bloggs)", order.customer_name
      assert_equal "Joe Bloggs (Widgets Inc)", order.billing_name
      assert_equal "Joe Bloggs (Widgets Inc)", order.delivery_name
    end
    
    test "money calculations" do
      product1 = create(:yealink_t22p, :initial_stock => 100)
      product2 = create(:snom_870, :initial_stock => 100)
      order = create(:order)
      
      assert_equal false, order.has_items?
      assert_equal true, order.empty?
      
      # add the first item
      item1 = order.order_items.create!(:quantity => 2, :ordered_item => product1)
      assert_equal BigDecimal(100), item1.unit_price
      assert_equal BigDecimal(50), item1.unit_cost_price
      assert_equal BigDecimal(40), item1.tax_amount
      assert_equal BigDecimal(20), item1.tax_rate
      assert_equal BigDecimal(200), item1.sub_total
      assert_equal BigDecimal(240), item1.total
      
      assert_equal BigDecimal(200), order.total_before_tax
      assert_equal BigDecimal(40), order.tax
      assert_equal BigDecimal(240), order.total
      
      assert_equal 2, order.total_items
      assert_equal true, order.has_items?
      assert_equal false, order.empty?
      
      # add another item
      item2 = order.order_items.create!(:quantity => 1, :ordered_item => product2)
      assert_equal BigDecimal(250), item2.unit_price
      assert_equal BigDecimal(125), item2.unit_cost_price
      assert_equal BigDecimal(50), item2.tax_amount
      assert_equal BigDecimal(20), item2.tax_rate
      assert_equal BigDecimal(250), item2.sub_total
      assert_equal BigDecimal(300), item2.total
      
      assert_equal 3, order.total_items
      
      # Test the order totals
      assert_equal BigDecimal(450), order.total_before_tax
      assert_equal BigDecimal(90), order.tax
      assert_equal BigDecimal(540), order.total
    end
    
    test "weight calculations" do
      order = build_order_with_products(:initial_stock => [100,100])
            
      item1 = order.order_items[0]
      assert_equal BigDecimal(1.5,8), item1.weight
      assert_equal BigDecimal(3), item1.total_weight

      item2 = order.order_items[1]
      assert_equal BigDecimal(2), item2.weight
      assert_equal BigDecimal(2), item2.total_weight

      assert_equal BigDecimal(5), order.total_weight
      assert_equal true, order.delivery_required?
    end
    
    private
    
    def build_order_with_products(options = {})
      order = create(:order)

      product1 = create(:yealink_t22p, :initial_stock => options[:initial_stock][0])
      item1 = order.order_items.create!(:quantity => 2, :ordered_item => product1)

      product2 = create(:snom_870, :initial_stock => options[:initial_stock][1])
      item2 = order.order_items.create!(:quantity => 1, :ordered_item => product2)
      
      order
    end
    
  end
end
