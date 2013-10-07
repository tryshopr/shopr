class Shoppe::Product < ActiveRecord::Base
  
  # Set the table name
  self.table_name = 'shoppe_products'  
  
  # Attachments
  attachment :default_image
  attachment :data_sheet
  
  # Relationships
  belongs_to :product_category, :class_name => 'Shoppe::ProductCategory'
  has_many :order_items, :dependent => :restrict_with_exception, :class_name => 'Shoppe::OrderItem'
  has_many :orders, :through => :order_items, :class_name => 'Shoppe::Order'
  
  # Validations
  validates :product_category_id, :presence => true
  validates :title, :presence => true
  validates :permalink, :presence => true, :uniqueness => true
  validates :sku, :presence => true
  validates :description, :presence => true
  validates :short_description, :presence => true
  validates :weight, :numericality => true
  validates :price, :numericality => true
  validates :tax_rate, :numericality => true
  validates :stock, :numericality => {:only_integer => true}
  
  # Set the permalink
  before_validation { self.permalink = self.title.parameterize if self.permalink.blank? && self.title.is_a?(String) }
  
  # Scopes
  scope :active, -> { where(:active => true) }
  scope :featured, -> {where(:featured => true)}
  
  # Is this product currently in stock?
  def in_stock?
    stock > 0
  end
  
  # Remove the provided number of units from the current stock level of this product
  def update_stock_level(purchased = 1)
    self.stock -= purchased
    self.save!
  end
  
  # Specify which attributes can be searched
  def self.ransackable_attributes(auth_object = nil)
    ["id", "title", "sku"] + _ransackers.keys
  end
  
  # Specify which associations can be searched
  def self.ransackable_associations(auth_object = nil)
    []
  end
  
  
end
