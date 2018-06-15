require 'rails/generators'

module Shopr
  class SetupGenerator < Rails::Generators::Base
    def create_route
      route "mount Shopr::Engine, at: '/shopr'"
    end
  end
end
