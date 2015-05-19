require 'test_helper'

module Shoppe
  class ProductCategoriesTest < ActiveSupport::TestCase

    test "hierarchy_array" do
      parent = create(:parent_category_with_child)
      child = parent.reload.children.first

      assert_equal Array, child.hierarchy_array.class
      assert_equal 2, child.hierarchy_array.count
      assert_equal parent, child.hierarchy_array.first
      assert_equal child, child.hierarchy_array.last
    end

  end
end
