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
      # create some products with some stock (so it doesn't get in our way)
      product1 = create(:yealink_t22p, :initial_stock => 100)
      product2 = create(:snom_870, :initial_stock => 100)

      # create an order
      order = create(:order)
      
      # check order items
      assert_equal false, order.has_items?
      assert_equal true, order.empty?
      
      # add the first item
      item1 = order.order_items.create!(:quantity => 2, :ordered_item => product1)
      
      # check all prices for the first item
      assert_equal BigDecimal(100), item1.unit_price
      assert_equal BigDecimal(50), item1.unit_cost_price
      assert_equal BigDecimal(40), item1.tax_amount
      assert_equal BigDecimal(20), item1.tax_rate
      assert_equal BigDecimal(200), item1.sub_total
      assert_equal BigDecimal(240), item1.total
      
      # check that no item prices have been persisted
      assert_equal nil, item1.read_attribute(:unit_price)
      assert_equal nil, item1.read_attribute(:unit_cost_price)
      assert_equal nil, item1.read_attribute(:tax_amount)
      assert_equal nil, item1.read_attribute(:tax_rate)
      
      # check the order's totals are looking OK
      assert_equal BigDecimal(200), order.total_before_tax
      assert_equal BigDecimal(40), order.tax
      assert_equal BigDecimal(240), order.total
      
      # check the item totals are OK
      assert_equal 2, order.total_items
      assert_equal true, order.has_items?
      assert_equal false, order.empty?
      
      # add another item
      item2 = order.order_items.create!(:quantity => 1, :ordered_item => product2)
      
      # check all prices for the second item
      assert_equal BigDecimal(250), item2.unit_price
      assert_equal BigDecimal(125), item2.unit_cost_price
      assert_equal BigDecimal(50), item2.tax_amount
      assert_equal BigDecimal(20), item2.tax_rate
      assert_equal BigDecimal(250), item2.sub_total
      assert_equal BigDecimal(300), item2.total
      
      # check item total again
      assert_equal 3, order.total_items
      
      # check order totals again
      assert_equal BigDecimal(450), order.total_before_tax
      assert_equal BigDecimal(90), order.tax
      assert_equal BigDecimal(540), order.total
    end
    
    test "weight calculations" do
      order = build_order_with_products
      
      # check the first item
      item1 = order.order_items[0]
      assert_equal BigDecimal(1.5,8), item1.weight
      assert_equal BigDecimal(3), item1.total_weight
      
      # check the second item
      item2 = order.order_items[1]
      assert_equal BigDecimal(2), item2.weight
      assert_equal BigDecimal(2), item2.total_weight
      
      # check the order looks good too
      assert_equal BigDecimal(5), order.total_weight
      assert_equal true, order.delivery_required?
    end
    
    test "delivery services" do
      create_environment
      order = build_order_with_products(:initial_stock => 10)
      # check the order requires delivery
      assert_equal true, order.delivery_required?
      # check that the default delivery service was automatically selected
      assert_equal DeliveryService.find_by_code('ND'), order.delivery_service
      # check that there are two other services available
      assert_equal 2, order.available_delivery_services.size
      # check that the price has been made available
      assert_equal BigDecimal(8), order.delivery_price
      assert_equal BigDecimal(4), order.delivery_cost_price
      assert_equal BigDecimal(1.6,8), order.delivery_tax_amount
      assert_equal BigDecimal(20), order.delivery_tax_rate
      # ensure this information is not persisted, before confirmation that'd be
      # a pain in everyone's arse.
      assert_equal nil, order.read_attribute(:delivery_price)
      assert_equal nil, order.read_attribute(:delivery_cost_price)
      assert_equal nil, order.read_attribute(:delivery_tax_amount)
      assert_equal nil, order.read_attribute(:delivery_tax_rate)
    end
    
    test "stock control" do
      # create an environment and an order
      create_environment
      order = create(:order)
      
      # create a product with no stock and try to add it to the order, it will fail
      # validation when saved.
      product1 = create(:yealink_t22p, :initial_stock => 0)
      item1 = order.order_items.create(:quantity => 1, :ordered_item => product1)
      assert_equal false, item1.valid?
      assert_equal false, item1.errors[:quantity].empty?

      # create a product with some stock but not enough to complete the order
      product2 = create(:snom_870, :initial_stock => 2)
      item2 = order.order_items.create(:quantity => 5, :ordered_item => product2)
      assert_equal false, item2.valid?
      assert_equal false, item2.errors[:quantity].empty?
    end
    
    test "confirmation" do
      # create an environment and an order
      create_environment
      order = build_order_with_products
      # confirm it then, we want nothing to raise
      order.confirm!
      # ensure the object has been marked as received
      assert_equal 'received', order.status
      assert_equal true, order.received?
      assert_equal true, order.received_at.is_a?(Time)
      # check that all order items have had their prices persisted 
      # to the database
      order.order_items.each do |item|
        assert_equal true, item.read_attribute(:unit_price).is_a?(BigDecimal)
        assert_equal true, item.read_attribute(:unit_cost_price).is_a?(BigDecimal)
        assert_equal true, item.read_attribute(:tax_rate).is_a?(BigDecimal)
      end
    end
    
    #test "confirmation fails when there isn't enough stock to complete the order (unless stock control is disabled)"
    #test "confirmation fails when there's no appropriate delivery service (unless non is required)"
    #test "item prices, tax amounts & weights can be overridden"
    #test "acceptance"
    #test "rejection"
    #test "shipping"
    
    private
    
    def build_order_with_products(options = {})
      order = create(:order)
      # create a product and a line
      product1 = create(:yealink_t22p, :initial_stock => 10)
      item1 = order.order_items.create!(:quantity => 2, :ordered_item => product1)
      # create another product and a link
      product2 = create(:snom_870, :initial_stock => 10)
      item2 = order.order_items.create!(:quantity => 1, :ordered_item => product2)
      # return the order
      order
    end
    
    def create_environment
      # add delivery services
      create(:delivery_service_with_prices)
      create(:saturday_delivery_with_prices)
      # add some countries
      create(:uk)
      create(:us)
      create(:france)
    end
    
  end
end
