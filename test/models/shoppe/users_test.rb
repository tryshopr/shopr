require 'test_helper'

module Shoppe
  class UsersTest < ActiveSupport::TestCase
    
    test "authentication" do
      user = create(:user)
      authed_user = User.authenticate('adam@niftyware.io', 'llamafarm')
      assert_equal User, authed_user.class
      assert_equal user, authed_user
      authed_user = User.authenticate('adam@niftyware.io', 'invalid')
      assert_equal false, authed_user
    end
    
    test "full name" do
      user = build(:user)
      assert_equal "Adam Cooke", user.full_name
    end
    
    test "short name" do
      user = build(:user)
      assert_equal "Adam C", user.short_name
    end
    
  end
end
