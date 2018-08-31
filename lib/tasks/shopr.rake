namespace :shopr do
  desc 'Load seed data for the Shopr'
  task seed: :environment do
    require File.join(Shopr.root, 'db', 'seeds')
  end

  desc 'Create a default admin user'
  task create_default_user: :environment do
    Shopr::User.create(email: 'admin@example.com', password: 'password', password_confirmation: 'password', first_name: 'Default', last_name: 'Admin')
    puts
    puts '    New user has been created successfully.'
    puts
    puts '    E-Mail Address..: admin@example.com'
    puts '    Password........: password'
    puts
  end

  desc 'Import default set of countries'
  task import_countries: :environment do
    Shopr::CountryImporter.import
  end

  desc 'Run the key setup tasks for a new application'
  task setup: :environment do
    # TODO: Solve this problem with a better approach.
    if Rails.application.class.parent_name == "Dummy"
      Rake::Task['app:shopr:import_countries'].invoke if Shopr::Country.all.empty?
      Rake::Task['app:shopr:create_default_user'].invoke if Shopr::User.all.empty?
    else
      Rake::Task['shopr:import_countries'].invoke if Shopr::Country.all.empty?
      Rake::Task['shopr:create_default_user'].invoke if Shopr::User.all.empty?
    end
  end


  desc 'Converts nifty-attachment attachments to Shopr Attachments'
  task attachments: :environment do
    require 'nifty/attachments'

    attachments = Nifty::Attachments::Attachment.all

    attachments.each do |attachment|
      object = attachment.parent_type.constantize.find(attachment.parent_id)

      attach = object.attachments.build
      attach.role = attachment.role
      attach.file_name = attachment.file_name

      tempfile = Tempfile.new("attach-#{attachment.token}")
      tempfile.binmode
      tempfile.write(attachment.data)
      uploaded_file = ActionDispatch::Http::UploadedFile.new(tempfile: tempfile, filename: attachment.file_name, type: attachment.file_type)

      attach.file = uploaded_file
      attach.save!
    end
  end
end
