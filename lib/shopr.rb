require 'coffee-rails'
require 'sass-rails'
require 'jquery-rails'
require 'haml'
require 'devise'
require 'dynamic_form'
require 'kaminari'
require 'ransack'

require 'nifty/utils'
require 'nifty/key_value_store'
require 'nifty/dialog'
require 'carrierwave'

require 'shopr/settings_loader'

module Shopr
  class << self
    # The path to the root of the Shopr application
    #
    # @return [String]
    def root
      File.expand_path('..', __dir__)
    end

    # Set name space shopr table name prefix
    #
    # @return [String]
    def table_name_prefix
      'shopr_'
    end

    # Shopr settings as configured in the database
    #
    # @return [Shopr::Settings]
    def settings
      Thread.current[:shopr_settings] ||= Shopr::Settings.new(Shopr::Setting.to_hash)
    end

    # Clears the settings from the thread cache so they will be taken
    # from the database on next access
    #
    # @return [NilClass]
    def reset_settings
      Thread.current[:shopr_settings] = nil
    end

    # Defines a new set of settings which should be configrable from the settings page
    # in the Shopr UI.
    def add_settings_group(group, fields = [])
      settings_groups[group] ||= []
      settings_groups[group] = settings_groups[group] | fields
    end

    # All settings groups which are available for configuration on the settings page.
    #
    # @return [Hash]
    def settings_groups
      @settings_groups ||= {}
    end
  end
end

# Start your engines.
require 'shopr/engine'
