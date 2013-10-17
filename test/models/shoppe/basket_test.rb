require 'test_helper'

module Shoppe
  class BasketTest < ActiveSupport::TestCase
    
    setup do
      @order = Order.create
    end
    
    test "initial status" do
      assert @order.building?
    end
    
    test "basket has no items by default" do
      assert_equal false, @order.has_items?
    end
    
    test "adding products" do
      @order.order_items.add_product(Product.find_by_sku('YL-SIP-T20P'))
      @order.order_items.add_product(Product.find_by_sku('YL-SIP-T22P'))
      assert_equal true, @order.has_items?
      assert_equal 2, @order.total_items
    end
    
  end
end
