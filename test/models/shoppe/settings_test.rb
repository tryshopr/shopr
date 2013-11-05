require 'test_helper'

module Shoppe
  class SettingsTest < ActiveSupport::TestCase
    
    setup do
      Shoppe.reset_settings
    end
    
    test "settings are automatically loaded" do
      assert_equal true, Shoppe.settings.is_a?(Settings)
    end
    
    test "defaults are loaded" do
      assert_equal 'Widgets Inc.', Shoppe.settings.store_name
      assert_equal 'sales@example.com', Shoppe.settings.email_address
    end
    
    test "database settings can be loaded into a hash" do
      db_settings = Setting.to_hash
      assert_equal Hash, db_settings.class
      assert_equal true, db_settings.empty?
    end
    
    test "database settings can be set from a hash" do
      new_settings = {'store_name' => 'Another Store', 'email_address' => 'test@test.com'}
      assert Setting.update_from_hash(new_settings)
      assert_equal new_settings, Setting.to_hash
      assert_equal 'Another Store', Shoppe.settings.store_name
      assert_equal 'test@test.com', Shoppe.settings.email_address
    end
    
  end
end
