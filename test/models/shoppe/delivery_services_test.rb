require 'test_helper'

module Shoppe
  class DeliveryServicesTest < ActiveSupport::TestCase
    
    test "tracking urls can be generated" do
      # create an order and an environment
      create_environment
      order = create_order_with_products(:confirmed => true)
      user = create(:user)
      order.accept!(user)
      order.ship!('ABC123', user)
      assert_equal "http://sometrackingsite.com/ABC123/BH15+1NX/BH15+1NX", order.delivery_service.tracking_url_for(order)
    end
    
    test "prices can be returned for given weights" do
      ds = create(:delivery_service_with_prices)
      
      #0-1
      band1 = ds.delivery_service_prices.where(:min_weight => 0).first
      #1-10
      band2 = ds.delivery_service_prices.where(:min_weight => 1).first
      #10-50
      band3 = ds.delivery_service_prices.where(:min_weight => 10).first 

      assert_equal band1, ds.delivery_service_prices.for_weight(0).first      
      assert_equal band1, ds.delivery_service_prices.for_weight(0.5).first
      assert_equal band1, ds.delivery_service_prices.for_weight(1).first
      assert_equal band2, ds.delivery_service_prices.for_weight(1.001).first
      assert_equal band2, ds.delivery_service_prices.for_weight(5).first
      assert_equal band2, ds.delivery_service_prices.for_weight(10).first
      assert_equal band3, ds.delivery_service_prices.for_weight(11.001).first
      assert_equal band3, ds.delivery_service_prices.for_weight(11).first
      assert_equal band3, ds.delivery_service_prices.for_weight(50).first
      assert_equal nil, ds.delivery_service_prices.for_weight(51).first
      
      # test that multiple prices are returned when on the boundary, the first
      # will always be used.
      assert_equal 2, ds.delivery_service_prices.for_weight(1).size 
      assert_equal 2, ds.delivery_service_prices.for_weight(10).size
    end
    
  end
end
