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
    
    initializer 'shoppe.initialize' do |app|
      # Preload the config
      Shoppe.config
      
      # Load our migrations into the application's db/migrate path
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
    end
    
  end
end
