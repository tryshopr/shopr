require 'test_helper'

module Shoppe
  class OrderTest < ActiveSupport::TestCase
    test "the truth" do
      assert true
    end
    
    puts Order.count
  end
end
