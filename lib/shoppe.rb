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
    
  end
  
end

# Start your engines.
require "shoppe/engine"
