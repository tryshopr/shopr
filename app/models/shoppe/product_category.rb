class Shoppe::ProductCategory < ActiveRecord::Base
  
  include HasAttachments
  attachment :image
  
  has_many :products, :dependent => :restrict_with_exception
  
  scope :ordered, -> { order(:name) }
  
  validates :name, :presence => true
  validates :permalink, :presence => true, :uniqueness => true
  
  before_validation { self.permalink = self.name.parameterize if self.permalink.blank? && self.name.is_a?(String) }
  
end
