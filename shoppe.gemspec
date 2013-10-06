$:.push File.expand_path("../lib", __FILE__)

require "shoppe/version"

Gem::Specification.new do |s|
  s.name        = "shoppe"
  s.version     = Shoppe::VERSION
  s.authors     = ["Adam Cooke"]
  s.email       = ["adam@niftyware.io"]
  s.homepage    = "http://shoppe.niftyware.io"
  s.summary     = "Just an e-commerce platform."
  s.description = "Just an e-commerce platform."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "bcrypt-ruby", "~> 3.0.0"
  s.add_dependency "dynamic_form"
  s.add_dependency "haml"
  s.add_dependency "ransack"
  s.add_dependency "kaminari"
  s.add_dependency "stripe"
  s.add_dependency "nifty-key-value-store"
  s.add_dependency "nifty-utils"
  s.add_dependency "jquery-rails"
  s.add_dependency "coffee-rails"
  s.add_dependency "sass-rails"
  s.add_dependency "uglifier"
  
  s.add_development_dependency "sqlite3"
end
