require 'test_helper'

module Shoppe
  class UserTest < ActiveSupport::TestCase
    
    test "authentication" do
      user = User.create(:email_address => 'adam@niftyware.io', :password => 'llamafarm', :password_confirmation => 'llamafarm', :first_name => 'Adam', :last_name => 'Cooke')

      authed_user = User.authenticate('adam@niftyware.io', 'llamafarm')
      assert_equal User, authed_user.class
      assert_equal user, authed_user
      authed_user = User.authenticate('adam@niftyware.io', 'invalid')
      assert_equal false, authed_user
    end
    
    test "full name" do
      user = User.new(:first_name => 'Adam', :last_name => 'Cooke')
      assert_equal "Adam Cooke", user.full_name
    end
    
    test "short name" do
      user = User.new(:first_name => 'Adam', :last_name => 'Cooke')
      assert_equal "Adam C", user.short_name
    end
    
  end
end
