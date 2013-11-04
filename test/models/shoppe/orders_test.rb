require 'test_helper'

module Shoppe
  class OrdersTest < ActiveSupport::TestCase
    
    test "a completely clean new order" do
      order = Order.new
      assert_equal true, order.building?
      assert_equal false, order.received?
      assert_equal true, order.empty?
      assert_equal 0, order.total_items
      assert_equal false, order.has_items?
      assert_equal nil, order.number
      
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
    
  end
end
