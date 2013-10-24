require 'rails/generators'
module Shoppe
  class SetupGenerator < Rails::Generators::Base
    
    def create_route
      route 'mount Shoppe::Engine => "/shoppe"'
    end

  end
end
