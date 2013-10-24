require "coffee-rails"
require "sass-rails"
require "jquery-rails"
require 'haml'
require 'bcrypt'
require 'dynamic_form'
require 'kaminari'
require 'ransack'

require 'nifty/utils'
require 'nifty/key_value_store'
require 'nifty/attachments'
require 'nifty/dialog'

module Shoppe
  
  class Error < StandardError; end
  
  class << self
    
    def root
      File.expand_path('../../', __FILE__)
    end
    
    def settings
      Thread.current[:shoppe_settings] ||= Shoppe::Settings.new(Shoppe::Setting.to_hash)
    end
    
    def reset_settings
      Thread.current[:shoppe_settings] = nil
    end
    
    def add_settings_group(group, fields = [])
      settings_groups[group]  ||= []
      settings_groups[group]    = settings_groups[group] | fields
    end
    
    def settings_groups
      @setting_groups ||= {}
    end
    
  end
  
end

# Start your engines.
require "shoppe/engine"
