# == Schema Information
#
# Table name: shoppe_payments
#
#  id         :integer          not null, primary key
#  order_id   :integer
#  amount     :decimal(8, 2)
#  reference  :string(255)
#  method     :string(255)
#  exported   :boolean          default(FALSE)
#  created_at :datetime
#  updated_at :datetime
#

module Shoppe
  class Payment < ActiveRecord::Base
    
    # Relationships
    belongs_to :order, :class_name => 'Shoppe::Order'
    belongs_to :parent, :class_name => "Shoppe::Payment", :foreign_key => "parent_payment_id"
    
    # Validations
    validates :amount, :numericality => true
    validates :reference, :presence => true
    validates :method, :presence => true
    
    # Properties can be assigned to a payment which may be useful
    key_value_store :properties
    
    after_create :cache_amount_paid
    after_destroy :cache_amount_paid
    
    before_destroy do
      if self.parent
        self.parent.update_attribute(:amount_refunded, self.parent.amount_refunded + amount)
      end
    end
    
    def refund?
      self.amount < BigDecimal(0)
    end
    
    def refunded?
      self.amount_refunded > BigDecimal(0)
    end
    
    def refundable_amount
      refundable? ? (self.amount - self.amount_refunded) : BigDecimal(0.0)
    end
    
    def refund!(amount)
      amount = BigDecimal(amount)
      if refundable_amount >= amount
        transaction do
          self.class.create(:parent => self, :order_id => self.order_id, :amount => 0-amount, :method => self.method, :reference => reference)
          self.update_attribute(:amount_refunded, self.amount_refunded + amount)
          true
        end
      else
        raise Shoppe::Errors::RefundFailed, :message => "Refunds must be less than the payment (#{refundable_amount})"
      end
    end
    
    private
    
    def cache_amount_paid
      self.order.update_attribute(:amount_paid, self.order.payments.sum(:amount))
    end
    
  end
end
