require 'test_helper'

module Shopr
  class UsersTest < ActiveSupport::TestCase
    # test 'authentication' do
    #   user = create(:user)
    #   authed_user = User.authenticate('someone@something.com', 'password')
    #   assert_equal User, authed_user.class
    #   assert_equal user, authed_user
    #   authed_user = User.authenticate('someone@something.com', 'invalid')
    #   assert_equal false, authed_user
    # end

    test 'full name' do
      user = build(:user)
      assert_equal 'Someone Something', user.full_name
    end

    test 'short name' do
      user = build(:user)
      assert_equal 'Someone S', user.short_name
    end
  end
end
