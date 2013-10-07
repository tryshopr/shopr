require 'haml'
require 'bcrypt'
require 'dynamic_form'
require 'kaminari'
require 'ransack'
require 'nifty/utils'
require 'nifty/key_value_store'
require 'nifty/attachments'

module Shoppe
  
  class Error < StandardError; end
  
  class << self
    def root
      File.expand_path('../../', __FILE__)
    end
    
    def config
      @config ||= begin
        path = Rails.root.join('config', 'shoppe.yml')
        if File.exist?(path)
          config = YAML.load_file(path).with_indifferent_access
          setup_config(config)
          config
        else
          $stderr.puts "Shoppe configuration file missing at #{path}"
          {}
        end
      end
    end
    
    def setup_config(config)
      ActionMailer::Base.smtp_settings = config[:smtp_settings] if config[:smtp_settings]
    end
  end
  
end

# Start your engines.
require "shoppe/engine"
