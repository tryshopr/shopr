module Shoppe
  class OrderItem < ActiveRecord::Base
  
    # Set the table name
    self.table_name = 'shoppe_order_items'
  
    # Relationships
    belongs_to :order, :class_name => 'Shoppe::Order'
    belongs_to :ordered_item, :polymorphic => true
    has_many :stock_level_adjustments, :as => :parent, :dependent => :nullify, :class_name => 'Shoppe::StockLevelAdjustment'
  
    # Validations
    validates :quantity, :numericality => true
  
    before_validation do
      self.weight = self.quantity * self.ordered_item.weight
    end
  
    # This allows you to add a product to the scoped order. For example Order.first.order_items.add_product(...).
    # This will either increase the quantity of the value in the order or create a new item if one does not
    # exist already.
    def self.add_item(ordered_item, quantity = 1)
      transaction do
        if existing = self.where(:ordered_item_id => ordered_item.id, :ordered_item_type => ordered_item.class.to_s).first
          existing.increase!(quantity)
          existing
        else
          new_item = self.create(:ordered_item => ordered_item, :quantity => 0)
          new_item.increase!(quantity)
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
        unless self.in_stock?
          raise Shoppe::Errors::NotEnoughStock, :ordered_item => self.ordered_item, :requested_stock => self.quantity
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
  
    # Return the unit price for the item
    def unit_price
      @unit_price ||= read_attribute(:unit_price) || ordered_item.try(:price) || 0.0
    end
  
    # Return the cost price for the item
    def unit_cost_price
      @unit_cost_price ||= read_attribute(:unit_cost_price) || ordered_item.try(:cost_price) || 0.0
    end
  
    # Return the tax rate for the item
    def tax_rate
      @tax_rate ||= read_attribute(:tax_rate) || ordered_item.try(:tax_rate).try(:rate_for, self.order) || 0.0 
    end
  
    # Return the total tax for the item
    def tax_amount
      @tax_amount ||= read_attribute(:tax_amount) || (self.sub_total / BigDecimal(100)) * self.tax_rate
    end
  
    # Return the total cost for the product
    def total_cost
      quantity * unit_cost_price
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
      write_attribute :unit_price, self.unit_price
      write_attribute :unit_cost_price, self.unit_cost_price
      write_attribute :tax_rate, self.tax_rate
      write_attribute :tax_amount, self.tax_amount
      save!
    
      if self.ordered_item.stock_control?
        self.ordered_item.stock_level_adjustments.create(:parent => self, :adjustment => 0 - self.quantity, :description => "Order ##{self.order.number} deduction")
      end
    end
  
    # This method will be trigger when the parent order is accepted.
    def accept!
    end
  
    # This method will be trigger when the parent order is rejected.
    def reject!
      self.stock_level_adjustments.destroy_all
    end
  
    # Do we have the stock needed to fulfil this order?
    def in_stock?
      if self.ordered_item.stock_control?
        self.ordered_item.stock >= self.quantity
      else
        true
      end
    end
  
    # Validate the stock level against the product and update as appropriate. This method will be executed
    # before an order is completed. If we have run out of this product, we will update the quantity to an
    # appropriate level (or remove the order item) and return the object.
    def validate_stock_levels
      if in_stock?
        false
      else
        self.quantity = self.ordered_item.stock
        self.quantity == 0 ? self.destroy : self.save!
        self
      end
    end
  
  end
end
