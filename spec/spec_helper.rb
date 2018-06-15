ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'factory_bot_rails'
require 'shoulda-matchers'

# Load support files
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Set Factory Girl factories locations
# first init will load factories, this should only run on subsequent reloads
unless FactoryBot.factories.blank?
  FactoryBot.factories.clear
  FactoryBot.definition_file_paths << File.join(File.dirname(__FILE__), 'factories')
  FactoryBot.find_definitions
end

# Load Shoulda
Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include FactoryBot::Syntax::Methods
end
