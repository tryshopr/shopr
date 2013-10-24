module Shoppe
  class SettingsLoader
    
    def initialize(app)
      @app = app
    end
    
    def call(env)
      Shoppe.reset_settings
      @app.call(env)
    ensure
      Shoppe.reset_settings
    end
    
  end
end
