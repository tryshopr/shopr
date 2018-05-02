begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path('spec/dummy/Rakefile', __dir__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

# namespace :shopr do
#   desc 'Publish the release notes'
#   task :changelog do
#     system 'scp -P 32032 CHANGELOG.md vdt@185.44.252.32:/app/docs/CHANGELOG.md'
#   end

#   desc 'Publish RDoc documentation from doc to api.tryshopr.com'
#   task :docs do
#     if File.exist?('Rakefile')
#       system 'yard'
#       system 'ssh root@vm.adamcooke.io rm -Rf /var/www/shopr-api'
#       system 'scp -r doc root@vm.adamcooke.io:/var/www/shopr-api'
#       system 'rm -Rf doc'
#     end
#   end
# end
