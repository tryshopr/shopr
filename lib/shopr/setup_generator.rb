require 'rails/generators'
module Shopr
  class SetupGenerator < Rails::Generators::Base
    def create_route
      route 'mount Shopr::Engine => "/shopr"'
    end
  end
end
