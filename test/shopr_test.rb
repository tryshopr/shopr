require 'test_helper'

class ShoprTest < ActiveSupport::TestCase
  test 'truth' do
    assert_kind_of Module, Shopr
  end

  test 'root path is set' do
    assert_equal File.expand_path('../../', __FILE__), Shopr.root
  end
end
