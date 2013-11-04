ENV["RAILS_ENV"] = "test"
require File.expand_path("../app/config/environment.rb",  __FILE__)
require "rails/test_help"

# Factory Girl 
require 'factory_girl'
FactoryGirl.find_definitions
class ActiveSupport::TestCase
  include FactoryGirl::Syntax::Methods
end
