module Shopr
  class SettingsLoader
    def initialize(app)
      @app = app
    end

    def call(env)
      Shopr.reset_settings
      @app.call(env)
    ensure
      Shopr.reset_settings
    end
  end
end
