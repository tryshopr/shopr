module Shoppe
  class Order < ActiveRecord::Base
    
    belongs_to :billing_country, :class_name => 'Shoppe::Country', :foreign_key => 'billing_country_id'
    has_many :payments, :dependent => :destroy, :class_name => 'Shoppe::Payment'
    
    with_options :if => Proc.new { |o| !o.building? } do |order|
      order.validates :first_name, :presence => true
      order.validates :last_name, :presence => true
      order.validates :billing_address1, :presence => true
      order.validates :billing_address3, :presence => true
      order.validates :billing_address4, :presence => true
      order.validates :billing_postcode, :presence => true
      order.validates :billing_country, :presence => true
    end
    
    # The name for billing purposes
    def billing_name
      company.blank? ? full_name : "#{full_name} (#{company})"
    end
    
    # The total cost of the order
    def total_cost
      self.delivery_cost_price + 
      order_items.inject(BigDecimal(0)) { |t, i| t + i.total_cost }
    end
  
    # Return the price for the order
    def profit
      total_before_tax - total_cost
    end
  
    # The total price of the order before tax
    def total_before_tax
      self.delivery_price +
      order_items.inject(BigDecimal(0)) { |t, i| t + i.sub_total }
    end
  
    # The total amount of tax due on this order
    def tax
      self.delivery_tax_amount +
      order_items.inject(BigDecimal(0)) { |t, i| t + i.tax_amount }
    end
  
    # The total of the order including tax
    def total
      self.delivery_price + 
      self.delivery_tax_amount + 
      order_items.inject(BigDecimal(0)) { |t, i| t + i.total }
    end
    
    # The total amount due on the order
    def balance
      @balance ||= total - amount_paid
    end
    
    def payment_outstanding?
      balance > BigDecimal(0)
    end
    
    def paid_in_full?
      !payment_outstanding?
    end
    
    # The total of the order including tax in pence
    def total_in_pence
      (total * BigDecimal(100)).to_i
    end
  
    # Is the order invoiced?
    def invoiced?
      !invoice_number.blank?
    end
    
  end
end
