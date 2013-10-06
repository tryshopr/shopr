module Shoppe
  class Engine < ::Rails::Engine
    isolate_namespace Shoppe
    
    config.autoload_paths << File.join(Shoppe.root, 'lib')
    
    initializer 'shoppe.initialize' do |app|
      # Preload the config
      Shoppe.config
      
      # Load our migrations into the application's db/migrate path
      config.paths["db/migrate"].expanded.each do |expanded_path|
        app.config.paths["db/migrate"] << expanded_path
      end
      
    end
    
  end
end
