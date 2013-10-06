require 'haml'
require 'bcrypt'
require 'dynamic_form'
require 'kaminari'
require 'ransack'
require 'nifty/utils'

require 'nifty/key_value_store'
require 'nifty/key_value_store/key_value_pair'
Nifty::KeyValueStore::KeyValuePair.table_name = 'shoppe_key_value_store'


module Shoppe
  
  class Error < StandardError; end
  
  class << self
    def root
      File.expand_path('../../', __FILE__)
    end
    
    def config
      @config ||= begin
        config = YAML.load_file(Rails.root.join('config', 'shoppe.yml')).with_indifferent_access
        setup_config(config)
        config
      end
    end
    
    def setup_config(config)
      ActionMailer::Base.smtp_settings = config[:smtp_settings] if config[:smtp_settings]
    end
  end
  
end

# Start your engines.
require "shoppe/engine"
