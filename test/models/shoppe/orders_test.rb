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
      order.separate_delivery_address = true
      order.delivery_name = 'Michael Jones'
      assert_equal "Michael Jones", order.delivery_name
    end
    
    test "order string generation (for an order with a company)" do
      order = create(:order, :company => "Widgets Inc")
      assert_equal "Joe Bloggs", order.full_name
      assert_equal "Widgets Inc (Joe Bloggs)", order.customer_name
      assert_equal "Joe Bloggs (Widgets Inc)", order.billing_name
      assert_equal "Joe Bloggs (Widgets Inc)", order.delivery_name
      order.separate_delivery_address = true
      order.delivery_name = 'Michael Jones'
      assert_equal "Michael Jones", order.delivery_name
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
      assert_equal BigDecimal(200), order.items_sub_total
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
      assert_equal BigDecimal(450), order.items_sub_total
      assert_equal BigDecimal(90), order.tax
      assert_equal BigDecimal(540), order.total
    end
    
    test "weight calculations" do
      order = create_order_with_products
      
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
      order = create_order_with_products(:initial_stock => 10)
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
      # check that the `items_sub_total` method returns the total price before tax minus
      # any delivery
      assert_equal order.total_before_tax - order.delivery_price, order.items_sub_total
      
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
      order = create_order_with_products
      # confirm it then, we want nothing to raise
      assert_nothing_raised { order.confirm! }
      # ensure the object has been marked as received
      assert_equal 'received', order.status
      assert_equal true, order.received?
      assert_equal true, order.received_at.is_a?(Time)
    end
    
    test "item prices are persisted when confirming an order" do
      create_environment
      order = create_order_with_products
      # check all attributes are nil to begin with
      order.order_items.each do |item|
        assert_equal nil, item.read_attribute(:unit_price)
        assert_equal nil, item.read_attribute(:unit_cost_price)
        assert_equal nil, item.read_attribute(:tax_rate)
      end
      # confirm it
      assert_nothing_raised { order.confirm! }
      # check they are all now big decimals
      order.order_items.each do |item|
        assert_equal true, item.read_attribute(:unit_price).is_a?(BigDecimal)
        assert_equal true, item.read_attribute(:unit_cost_price).is_a?(BigDecimal)
        assert_equal true, item.read_attribute(:tax_rate).is_a?(BigDecimal)
      end
    end
    
    test "delivery prices are persisted when confirming an order" do
      create_environment
      order = create_order_with_products
      # check prices aren't persisted before confirmation
      assert_equal nil, order.read_attribute(:delivery_service_id)
      assert_equal nil, order.read_attribute(:delivery_price)
      assert_equal nil, order.read_attribute(:delivery_cost_price)
      assert_equal nil, order.read_attribute(:delivery_tax_rate)
      assert_equal nil, order.read_attribute(:delivery_tax_amount)
      # confirm
      assert_nothing_raised { order.confirm! }
      # check prices are now persisted after confirmation
      assert_equal true, order.read_attribute(:delivery_service_id) > 0
      assert_equal true, order.read_attribute(:delivery_price).is_a?(BigDecimal)
      assert_equal true, order.read_attribute(:delivery_cost_price).is_a?(BigDecimal)
      assert_equal true, order.read_attribute(:delivery_tax_rate).is_a?(BigDecimal)
    end
    
    test "stock is allocated when when confirming an order" do
      create_environment
      order = create_order_with_products
      # check no stock has been allocated yet
      order.order_items.each do |item|
        assert_equal 0, item.allocated_stock
        assert_equal item.quantity, item.unallocated_stock
      end
      # confirm
      assert_nothing_raised { order.confirm! }
      # ensure that stock has been allocated
      order.order_items.each do |item|
        assert_equal item.quantity, item.allocated_stock
        assert_equal 0, item.unallocated_stock
        assert_equal false, item.stock_level_adjustments.empty?
        assert_equal item.quantity, 0 - item.stock_level_adjustments.sum(:adjustment)
        assert_equal true, item.in_stock?
      end
      # ensure that the stock has been updated for the products
      assert_equal 8, Product.find_by_sku('YT22P').stock
      assert_equal 9, Product.find_by_sku('SN870').stock
    end
    
    test "confirmation fails when there isn't enough stock to complete the order (and removes item without stock)" do
      # create an order (successfully)
      create_environment
      order = create_order_with_products
      # lose all stock of one of the items after it has been created
      item_to_lose = order.order_items.first
      item_to_lose.ordered_item.stock_level_adjustments.create!(:adjustment => -10, :description => 'No stock')
      # assert that an error is raised
      assert_raise(Errors::InsufficientStockToFulfil) { order.confirm! }
      # asert that the item which was not in stock was removed
      assert_equal true, item_to_lose.destroyed?
      # assert the the item's quantity was updated
      assert_equal 0, item_to_lose.quantity
    end
    
    test "confirmation fails when there isn't enough stock to complete the order (and updates item without stock)" do
      # create an order (successfully)
      create_environment
      order = create_order_with_products
      # lose all stock of one of the items after it has been created
      item_to_lose = order.order_items.first
      item_to_lose.ordered_item.stock_level_adjustments.create!(:adjustment => -9, :description => 'No stock')
      # assert that an error is raised
      assert_raise(Errors::InsufficientStockToFulfil) { order.confirm! }
      # asert that the item which was not in stock was not removed
      assert_equal false, item_to_lose.destroyed?
      # assert the the item's quantity was updated to the number in stock
      assert_equal 1, item_to_lose.quantity
    end
    
    test "confirmation fails when there's no appropriate delivery service" do
      # create a delivery service which cannot carry more than a 0.5kg
      ds = create(:first_class_post_with_prices)
      order = create_order_with_products
      # check delivery is actually required
      assert_equal true, order.delivery_required?
      # check the delivery service is null and ensure the order cannot be saved or confirmed
      assert_equal nil, order.delivery_service
      assert_raise(ActiveRecord::RecordInvalid) { order.save! }
      assert_raise(Errors::InappropriateDeliveryService) { order.confirm! }
      # force the delivery service to an inappropriate service and check it
      # still cannot be saved or confirmed
      order.delivery_service = ds
      assert_equal ds, order.delivery_service
      assert_raise(ActiveRecord::RecordInvalid) { order.save! }
      assert_raise(Errors::InappropriateDeliveryService) { order.confirm! }
      # clear the set delivery service
      order.delivery_service = nil
      # check that if a valid service exists, the order can be saved and confirmed
      ds = create(:delivery_service_with_prices)
      assert_equal ds, order.delivery_service
      assert_nothing_raised { order.save! }
      assert_nothing_raised { order.confirm! }
    end
    
    test "acceptance" do
      create_environment
      order = create_order_with_products(:confirmed => true)
      user = create(:user)
      assert_nothing_raised { order.accept!(user) }
      # ensure the order is updated
      assert_equal 'accepted', order.status
      assert_equal true, order.accepted?
      assert_equal true, order.received? # still received?
      assert_equal true, order.accepted_at.is_a?(Time)
      assert_equal user, order.accepter
    end
    
    test "rejection" do
      create_environment
      order = create_order_with_products(:confirmed => true)
      user = create(:user)
      assert_nothing_raised { order.reject!(user) }
      # ensure the order is rejected
      assert_equal 'rejected', order.status
      assert_equal true, order.rejected?
      assert_equal true, order.received?
      assert_equal false, order.accepted?
      assert_equal true, order.rejected_at.is_a?(Time)
      assert_equal user, order.rejecter
      # ensure that all stock has been unallocated
      order.order_items.each do |item|
        assert_equal 0, item.allocated_stock
        assert_equal item.quantity, item.unallocated_stock
      end
    end
    
    test "shipping" do
      create_environment
      order = create_order_with_products(:confirmed => true)
      user = create(:user)
      # accept the order as we cannot ship with an accepted order
      assert_nothing_raised { order.accept!(user) }
      # mark the order as shipped
      assert_nothing_raised { order.ship!('ABC123', user) }
      # check stuff
      assert_equal 'shipped', order.status
      assert_equal true, order.shipped?
      assert_equal true, order.shipped_at.is_a?(Time)
      assert_equal user, order.shipper
      assert_equal 'ABC123', order.consignment_number
    end
    
    test "appropriate delivery services are provided for orders based on their weight" do
      create_environment
      # create an empty order
      order = create(:order)
      # ensure that no delivery services are needed for an empty order and
      # that this is acceptable
      assert_equal [], order.delivery_service_prices
      assert_equal [], order.available_delivery_services
      assert_equal nil, order.delivery_service
      assert_equal true, order.valid_delivery_service?
      
      # add a light product to enact the lowest delivery price (0-1)
      product1 = create(:yealink_headset, :weight => 0.01, :initial_stock => 10)
      item1 = order.order_items.create!(:quantity => 1, :ordered_item => product1)
      assert_equal BigDecimal(0.01,8), order.total_weight
      # check to see what we have, we should have all three of our
      # delivery services
      assert_equal 3, order.available_delivery_services.size
      assert_equal 3, order.delivery_service_prices.size
      # check the default delivery service has been selected
      assert_equal DeliveryService.find_by_default(true), order.delivery_service
      # check that the prices for this service are correct
      assert_equal BigDecimal(5), order.delivery_price
      assert_equal BigDecimal(2.5,8), order.delivery_cost_price
      assert_equal BigDecimal(20), order.delivery_tax_rate
      assert_equal BigDecimal(1), order.delivery_tax_amount
      
      # add something a little heavier to get us into the next bracket (1-10)
      product2 = create(:snom_870, :weight => 1.2, :initial_stock => 10)
      item2 = order.order_items.create!(:quantity => 1, :ordered_item => product2)
      assert_equal BigDecimal(1.21,8), order.total_weight
      # check that the lowest service has vanished leaving us with sat & nD
      assert_equal 2, order.available_delivery_services.size
      assert_equal 2, order.delivery_service_prices.size
      assert_equal DeliveryService.find_by_default(true), order.delivery_service
      assert_equal BigDecimal(8), order.delivery_price
      assert_equal BigDecimal(4), order.delivery_cost_price
      assert_equal BigDecimal(20), order.delivery_tax_rate
      assert_equal BigDecimal(1.6,8), order.delivery_tax_amount

      # finally, we want to end up in the final bracket
      product3 = create(:yealink_t22p, :weight => 2.0, :initial_stock => 10)
      item2 = order.order_items.create!(:quantity => 10, :ordered_item => product3)
      assert_equal BigDecimal(21.21,8), order.total_weight
      # check that the lowest service has vanished leaving us with sat & nD
      assert_equal 2, order.available_delivery_services.size
      assert_equal 2, order.delivery_service_prices.size
      assert_equal DeliveryService.find_by_default(true), order.delivery_service
      assert_equal BigDecimal(12), order.delivery_price
      assert_equal BigDecimal(6), order.delivery_cost_price
      assert_equal BigDecimal(20), order.delivery_tax_rate
      assert_equal BigDecimal(2.4,8), order.delivery_tax_amount
    end

    test "that delivery details match the billing details if no seperate address has been given" do
      create_environment
      order = create_order_with_products
      assert_equal order.billing_address1, order.delivery_address1
      assert_equal order.billing_address2, order.delivery_address2
      assert_equal order.billing_address3, order.delivery_address3
      assert_equal order.billing_address4, order.delivery_address4
      assert_equal order.billing_postcode, order.delivery_postcode
      assert_equal order.billing_country, order.delivery_country
    end
    
    test "that delivery details are settable seperately when appropriate" do
      create_environment
      order = create_order_with_products
      # say we want a different address
      order.separate_delivery_address = true
      # check validations are happening
      assert_equal false, order.save
      assert_equal false, order.errors[:delivery_name].empty?
      assert_equal false, order.errors[:delivery_address1].empty?
      assert_equal false, order.errors[:delivery_address3].empty?
      assert_equal false, order.errors[:delivery_address4].empty?
      assert_equal false, order.errors[:delivery_postcode].empty?
      assert_equal false, order.errors[:delivery_country].empty? 
      # add some delivery details
      order.delivery_name = 'Dave Smith'
      order.delivery_address1 = 'Line 1'
      order.delivery_address2 = 'Line 2'
      order.delivery_address3 = 'Line 3'
      order.delivery_address4 = 'Line 4'      
      order.delivery_postcode = 'AB12 3CD'
      order.delivery_country = Country.find_by_code2('GB')
      # check it saves now
      assert_equal true, order.save
      # check the details are provided
      assert_equal 'Line 1', order.delivery_address1
      assert_equal 'Line 2', order.delivery_address2
      assert_equal 'Line 3', order.delivery_address3
      assert_equal 'Line 4', order.delivery_address4
      assert_equal 'AB12 3CD', order.delivery_postcode
      assert_equal Country.find_by_code2('GB'), order.delivery_country
    end
    
  end
end
