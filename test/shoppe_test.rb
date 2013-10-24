require 'test_helper'

class ShoppeTest < ActiveSupport::TestCase
  test "truth" do
    assert_kind_of Module, Shoppe
  end
  
  test "root path is set" do
    assert_equal File.expand_path('../../', __FILE__), Shoppe.root
  end
  
end
