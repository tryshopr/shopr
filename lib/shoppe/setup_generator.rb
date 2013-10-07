require 'rails/generators'
module Shoppe
  class SetupGenerator < Rails::Generators::Base
    
    def create_route
      route 'mount Shoppe::Engine => "/shoppe"'
    end
    
    def create_config_file
      create_file "config/shoppe.yml", File.read(File.join(Shoppe.root, 'config', 'shoppe.example.yml'))
    end

  end
end
