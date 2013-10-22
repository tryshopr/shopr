module Shoppe
  class Product < ActiveRecord::Base
  
    # Set the table name
    self.table_name = 'shoppe_products'  
  
    # Require some concerns
    require_dependency 'shoppe/product/product_attributes'
  
    # Attachments
    attachment :default_image
    attachment :data_sheet
  
    # Relationships
    belongs_to :product_category, :class_name => 'Shoppe::ProductCategory'
    belongs_to :tax_rate, :class_name => "Shoppe::TaxRate"
    has_many :order_items, :dependent => :restrict_with_exception, :class_name => 'Shoppe::OrderItem', :as => :ordered_item
    has_many :orders, :through => :order_items, :class_name => 'Shoppe::Order'
    has_many :stock_level_adjustments, :dependent => :destroy, :class_name => 'Shoppe::StockLevelAdjustment', :as => :item
  
    # Validations
    validates :product_category_id, :presence => true
    validates :name, :presence => true
    validates :permalink, :presence => true, :uniqueness => true
    validates :sku, :presence => true
    validates :description, :presence => true
    validates :short_description, :presence => true
    validates :weight, :numericality => true
    validates :price, :numericality => true
    validates :cost_price, :numericality => true, :allow_blank => true
  
    # Set the permalink
    before_validation { self.permalink = self.name.parameterize if self.permalink.blank? && self.name.is_a?(String) }
  
    # Scopes
    scope :active, -> { where(:active => true) }
    scope :featured, -> {where(:featured => true)}

    # Is this product currently in stock?
    def in_stock?
      stock > 0
    end
  
    # Return the total number of items currently in stock
    def stock
      @stock ||= self.stock_level_adjustments.sum(:adjustment)
    end
  
    # Specify which attributes can be searched
    def self.ransackable_attributes(auth_object = nil)
      ["id", "name", "sku"] + _ransackers.keys
    end
  
    # Specify which associations can be searched
    def self.ransackable_associations(auth_object = nil)
      []
    end
  
    # Search for products which include the guven attributes and return an active record
    # scope of these products. Chainable with other scopes and with_attributes methods.
    # For example:
    #
    #   Shoppe::Product.active.with_attribute('Manufacturer', 'Apple').with_attribute('Model', ['Macbook', 'iPhone'])
    def self.with_attributes(key, values)
      product_ids = Shoppe::ProductAttribute.searchable.where(:key => key, :value => values).pluck(:product_id).uniq
      where(:id => product_ids)
    end
  
  end
end
