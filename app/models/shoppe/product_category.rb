class Shoppe::ProductCategory < ActiveRecord::Base
  
  # Set the table name
  self.table_name = 'shoppe_product_categories'
  
  # Attachments
  attachment :image
  
  # Relationships
  has_many :products, :dependent => :restrict_with_exception, :class_name => 'Shoppe::Product'
  
  # Validations
  validates :name, :presence => true
  validates :permalink, :presence => true, :uniqueness => true

  # Scopes
  scope :ordered, -> { order(:name) }
  
  # Set the permalink
  before_validation { self.permalink = self.name.parameterize if self.permalink.blank? && self.name.is_a?(String) }
  
end
