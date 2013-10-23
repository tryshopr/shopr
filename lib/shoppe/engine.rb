module Shoppe
  class Engine < ::Rails::Engine
    isolate_namespace Shoppe
    
    if Shoppe.respond_to?(:root)
      config.autoload_paths << File.join(Shoppe.root, 'lib')
    end
    
    # We don't want any automatic generators in the engine.
    config.generators do |g|
      g.orm             :active_record
      g.test_framework  false
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end
    
    config.assets.precompile += ['shoppe/sub.css', 'shoppe/printable.css']
    
    initializer 'shoppe.initialize' do |app|
      # Preload the config
      Shoppe.config
      
      # Validate the initial config
      Shoppe.validate_live_config :store_name, :email_address, :currency_unit, :tax_name
      
      # Load our migrations into the application's db/migrate path
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
    
    generators do
      require 'shoppe/setup_generator'
    end
    
  end
end
