# == Schema Information
#
# Table name: shoppe_countries
#
#  id        :integer          not null, primary key
#  name      :string(255)
#  code2     :string(255)
#  code3     :string(255)
#  continent :string(255)
#  tld       :string(255)
#  currency  :string(255)
#  eu_member :boolean          default(FALSE)
#

module Shoppe
  class Country < ActiveRecord::Base

    # Set the table name
    self.table_name = 'shoppe_countries'

    # Relationships
    has_many :billed_orders, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Order', :foreign_key => 'billing_country_id'
    has_many :delivered_orders, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Order', :foreign_key => 'delivery_country_id'
    
    
    # Scopes
    scope :ordered, -> { order('shoppe_countries.name asc') }
    
  end
end
