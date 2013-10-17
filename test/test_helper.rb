ENV["RAILS_ENV"] = "test"
require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require "rails/test_help"

if Shoppe::Product.all.empty?
  puts "Loading Shoppe seed data as database seems to be empty..."
  Shoppe::Engine.load_seed
end
