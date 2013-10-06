class Shoppe::OrderItem < ActiveRecord::Base
  
  # Set the table name
  self.table_name = 'shoppe_order_items'
  
  # Relationships
  belongs_to :order, :class_name => 'Shoppe::Order'
  belongs_to :product, :class_name => 'Shoppe::Product'
  
  # Validations
  validates :quantity, :numericality => true
  
  # Set some values based on the selected product on validation
  before_validation do
    if self.product
      self.unit_price = self.product.price      if self.unit_price.blank?
      self.tax_rate   = self.product.tax_rate   if self.tax_rate.blank?
      if unit_price_changed? || quantity_changed?
        self.tax_amount = (self.sub_total / BigDecimal(100)) * self.tax_rate
      end
      
      if product_id_changed? || quantity_changed?
        self.weight = self.quantity * self.product.weight
      end
    end
  end
  
  # This allows you to add a product to the scoped order. For example Order.first.order_items.add_product(...).
  # This will either increase the quantity of the value in the order or create a new item if one does not
  # exist already.
  def self.add_product(product, quantity = 1)
    transaction do
      if existing = self.where(:product_id => product.id).first
        existing.increase!(quantity)
        existing
      else
        item = self.create(:product => product, :quantity => 0)
        item.increase!(quantity)
      end
    end
  end

  # This allows you to remove a product from an order. It will also ensure that the order's
  # custom delivery service is updated.
  def remove
    transaction do
      self.destroy!
      self.order.remove_delivery_service_if_invalid
    end
  end
  
  
  # Increase the quantity of items in the order by the number provided. Will raise an error if we don't have
  # the stock to do this.
  def increase!(amount = 1)
    transaction do
      self.quantity += amount
      if self.product.stock < self.quantity
        raise Shoppe::Errors::NotEnoughStock, :product => self.product, :requested_stock => self.quantity
      end
      self.save!
      self.order.remove_delivery_service_if_invalid
    end
  end
  
  # Decreases the quantity of items in the order by the number provided.
  def decrease!(amount = 1)
    transaction do
      self.quantity -= amount
      self.quantity == 0 ? self.destroy : self.save!
      self.order.remove_delivery_service_if_invalid
    end
  end
  
  # Return the sub total for the product
  def sub_total
    quantity * unit_price
  end
  
  # Return the total price including tax for the order line
  def total
    tax_amount + sub_total
  end
  
  # This method will be triggered when the parent order is confirmed. This should automatically
  # update the stock levels on the source product.
  def confirm!
    self.product.update_stock_level(quantity)
  end
  
  # Do we have the stock needed to fulfil this order?
  def in_stock?
    if self.product.respond_to?(:stock)
      self.product.stock >= self.quantity
    else
      true
    end
  end
  
  # Validate the stock level against the product and update as appropriate. This method will be executed
  # before an order is completed. If we have run out of this product, we will update the quantity to an
  # appropriate level (or remove the order item) and return the object.
  def validate_stock_levels
    unless in_stock?
      self.quantity = self.product.stock
      self.quantity == 0 ? self.destroy : self.save!
      self
    else
      false
    end
  end
  
end
