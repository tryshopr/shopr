# == Schema Information
#
# Table name: shoppe_payments
#
#  id                :integer          not null, primary key
#  order_id          :integer
#  amount            :decimal(8, 2)    default(0.0)
#  reference         :string(255)
#  method            :string(255)
#  confirmed         :boolean          default(TRUE)
#  refundable        :boolean          default(FALSE)
#  amount_refunded   :decimal(8, 2)    default(0.0)
#  parent_payment_id :integer
#  exported          :boolean          default(FALSE)
#  created_at        :datetime
#  updated_at        :datetime
#

module Shoppe
  class Payment < ActiveRecord::Base
    
    # The associated order
    #
    # @return [Shoppe::Order]
    belongs_to :order, :class_name => 'Shoppe::Order'
    
    # An associated payment (only applies to refunds)
    #
    # @return [Shoppe::Payment]
    belongs_to :parent, :class_name => "Shoppe::Payment", :foreign_key => "parent_payment_id"
    
    # Validatiosn
    validates :amount, :numericality => true
    validates :reference, :presence => true
    validates :method, :presence => true
    
    # Payments can have associated properties
    key_value_store :properties
    
    # Callbacks
    after_create :cache_amount_paid
    after_destroy :cache_amount_paid
    before_destroy { self.parent.update_attribute(:amount_refunded, self.parent.amount_refunded + amount) if self.parent }
    
    # Is this payment a refund?
    #
    # @return [Boolean]
    def refund?
      self.amount < BigDecimal(0)
    end
    
    # Has this payment had any refunds taken from it?
    #
    # @return [Boolean]
    def refunded?
      self.amount_refunded > BigDecimal(0)
    end
    
    # How much of the payment can be refunded
    #
    # @return [BigDecimal]
    def refundable_amount
      refundable? ? (self.amount - self.amount_refunded) : BigDecimal(0.0)
    end
    
    # Process a refund from this payment. 
    #
    # @param amount [String] the amount which should be refunded
    # @return [Boolean]
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
