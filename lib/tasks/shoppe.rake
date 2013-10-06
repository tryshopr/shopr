namespace :shoppe do
  desc "Load seed data for the Shoppe"
  task :seed => :environment do
    require File.join(Shoppe.root, 'db', 'seeds')
  end
end