require 'test_helper'

module Shoppe
  class UserTest < ActiveSupport::TestCase
    
    setup do
      @user = User.first
    end
    
    test "authentication" do
      user = User.authenticate('adam@niftyware.io', 'llamafarm')
      assert_equal User, user.class
      user = User.authenticate('adam@niftyware.io', 'invalid')
      assert_equal false, user
    end
    
    test "full name" do
      assert_equal "Adam Cooke", @user.full_name
    end
    
    test "short name" do
      assert_equal "Adam C", @user.short_name
    end
    
    test "user creation" do
      user = User.new
      assert_equal false, user.save
      user.first_name = 'Test'
      user.last_name = 'User'
      user.email_address = 'test@example.com'
      user.password = 'password'
      user.password_confirmation = 'password'
      assert_equal true, user.save
    end
    
  end
end
