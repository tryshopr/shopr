module Shopr
  class Engine < ::Rails::Engine
    isolate_namespace Shopr

    if Shopr.respond_to?(:root)
      config.autoload_paths << File.join(Shopr.root, 'lib')
      config.assets.precompile += ['shopr/sub.css', 'shopr/printable.css']
    end

    # We don't want any automatic generators in the engine.
    config.generators do |g|
      g.orm             :active_record
      g.test_framework  :rspec
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
      g.stylesheets     false
      g.javascripts     false
      g.helper          false
    end

    config.to_prepare do
      # Set Devise layout
      Devise::SessionsController.layout 'shopr/sub'

      Dir.glob(Rails.root + 'app/decorators/**/*_decorator*.rb').each do |c|
        require_dependency(c)
      end
    end

    initializer 'shopr.initialize' do |app|
      # Add the default settings
      Shopr.add_settings_group :system_settings, %i[store_name email_address currency_unit tax_name demo_mode]

      # Add middleware
      app.config.middleware.use Shopr::SettingsLoader

      # Load our migrations into the application's db/migrate path
      unless app.root.to_s.match root.to_s
        config.paths['db/migrate'].expanded.each do |expanded_path|
          app.config.paths['db/migrate'] << expanded_path
        end
      end

      # Load view helpers for the base application
      ActiveSupport.on_load(:action_view) do
        require 'shopr/view_helpers'
        ActionView::Base.send :include, Shopr::ViewHelpers
      end

      ActiveSupport.on_load(:active_record) do
        require 'shopr/model_extension'
        # ApplicationRecord.send :include, Shopr::ModelExtension
      end

      # Load default navigation
      require 'shopr/default_navigation'
    end

    generators do
      require 'shopr/setup_generator'
    end
  end
end
