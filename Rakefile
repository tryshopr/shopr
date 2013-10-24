begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

APP_RAKEFILE = File.expand_path("../test/app/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Bundler::GemHelper.install_tasks

require 'rake/testtask'
Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

namespace :shoppe do
  
  desc "Generate RDoc documentation into doc/"
  task :generate_docs do
    system("rm -Rf doc")
    system("bundle exec sdoc app/models lib README.rdoc")
  end
  
  desc "Publish RDoc documentation from doc to api.tryshoppe.com"
  task :publish_docs do
    if File.exist?("doc")
      system "ssh root@tryshoppe.com rm -Rf /var/www/shoppe-api"
      system "scp -r doc root@tryshoppe.com:/var/www/shoppe-api"
    else
      puts "No doc/ folder found to publish."
    end
  end
end

