$LOAD_PATH.push File.expand_path('lib', __dir__)

require 'shopr/version'

Gem::Specification.new do |s|
  s.name        = 'shopr'
  s.version     = Shopr::VERSION
  s.authors     = ['Dean Perry']
  s.email       = ['dean@voupe.com']
  s.homepage    = 'https://shoprgem.com'
  s.summary     = 'A fully featured ecommerce engine for Rails 5.2'
  s.licenses    = ['MIT']
  s.description = 'Shopr is a fully featured ecommerce engine for Rails 5.2 (forked from Shoppe)'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'awesome_nested_set' # , '~> 3.0.2'
  s.add_dependency 'bcrypt' # , '>= 3.1.2', '< 3.2'
  s.add_dependency 'devise'
  s.add_dependency 'dynamic_form' # , '~> 1.1', '>= 1.1.4'
  s.add_dependency 'haml' # , '>= 4.0', '< 5.0'
  s.add_dependency 'jquery-rails' # , '>= 3', '< 4.1'
  s.add_dependency 'kaminari' # , '>= 0.14.1', '< 0.17'
  s.add_dependency 'rails', '>= 5.0.0', '< 6.0.0'
  s.add_dependency 'ransack' # , '>= 1.2.0', '< 1.6.3'
  s.add_dependency 'roo' # , '>= 1.13.0', '< 1.14'

  s.add_dependency 'carrierwave' # , '~> 0.10.0'
  s.add_dependency 'coffee-rails' # , '~> 4'
  s.add_dependency 'fog' # , '~> 1.42.0'
  s.add_dependency 'mini_magick' # , '~> 4.2.7'
  s.add_dependency 'net-ssh' # , '~> 3.0.1'
  s.add_dependency 'nifty-dialog' # , '>= 1.0.7', '< 1.1'
  s.add_dependency 'nifty-key-value-store' # , '>= 1.0.1', '< 2.0.0'
  s.add_dependency 'nifty-utils' # , '>= 1.0', '< 1.1'
  s.add_dependency 'sass-rails' # , '~> 4.0'

  s.add_development_dependency 'markdown' # , '~> 1.0'
  # s.add_development_dependency 'mysql2' # , '~> 0.3'
  s.add_development_dependency 'sqlite3' # , '~> 1.3'
  s.add_development_dependency 'yard' # , '~> 0'
  s.add_development_dependency 'yard-activerecord' # , '~> 0'

  s.add_development_dependency 'brakeman' # , '~> 4.5'
  s.add_development_dependency 'factory_bot_rails' # , '~> 4.5' The factory_girl gem is deprecated.
  s.add_development_dependency 'rubocop' # , '~> 4.5'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rspec-core'
  s.add_development_dependency 'rspec-expectations'
  s.add_development_dependency 'rspec-mocks'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rspec-support'
  s.add_development_dependency 'shoulda-callback-matchers'
  s.add_development_dependency 'shoulda-matchers'
end
