module Shoppe
  class Country < ActiveRecord::Base

    # Set the table name
    self.table_name = 'shoppe_countries'

    # Relationships
    has_many :orders, :dependent => :restrict_with_exception
    
    # Scopes
    scope :ordered, -> { order('shoppe_countries.name asc') }
    
  end
end
