# app/models/application_record.rb
class ApplicationRecord < ActiveRecord::Base
  include Shopr::ModelExtension

  self.abstract_class = true
end
