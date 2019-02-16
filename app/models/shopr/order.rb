module Shopr
  class Order < ApplicationRecord
    EMAIL_REGEX = /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i.freeze
    PHONE_REGEX = /\A[+?\d\ \-x\(\)]{7,}\z/.freeze

    # Orders can have properties
    key_value_store :properties

    # Require dependencies
    require_dependency 'shopr/order/states'
    require_dependency 'shopr/order/actions'
    require_dependency 'shopr/order/billing'
    require_dependency 'shopr/order/delivery'

    # All items which make up this order
    has_many :order_items, dependent: :destroy, class_name: 'Shopr::OrderItem', inverse_of: :order
    accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: proc { |a| a['ordered_item_id'].blank? }

    # All products which are part of this order (accessed through the items)
    has_many :products, through: :order_items, class_name: 'Shopr::Product', source: :ordered_item, source_type: 'Shopr::Product'

    # The order can belong to a customer
    belongs_to :customer, class_name: 'Shopr::Customer'
    has_many :addresses, through: :customers, class_name: 'Shopr::Address'

    # Validations
    validates :token, presence: true
    with_options if: proc { |o| !o.building? } do
      validates :email_address, format: { with: EMAIL_REGEX }
      validates :phone_number, format: { with: PHONE_REGEX }
    end

    # Set some defaults
    before_validation { self.token = SecureRandom.uuid  if token.blank? }

    # Some methods for setting the billing & delivery addresses
    attr_accessor :save_addresses, :billing_address_id, :delivery_address_id

    # The order number
    #
    # @return [String] - the order number padded with at least 5 zeros
    def number
      id ? id.to_s.rjust(6, '0') : nil
    end

    # The length of time the customer spent building the order before submitting it to us.
    # The time from first item in basket to received.
    #
    # @return [Float] - the length of time
    def build_time
      return nil if received_at.blank?

      created_at - received_at
    end

    # The name of the customer in the format of "Company (First Last)" or if they don't have
    # company specified, just "First Last".
    #
    # @return [String]
    def customer_name
      company.blank? ? full_name : "#{company} (#{full_name})"
    end

    # The full name of the customer created by concatinting the first & last name
    #
    # @return [String]
    def full_name
      "#{first_name} #{last_name}"
    end

    # Is this order empty? (i.e. doesn't have any items associated with it)
    #
    # @return [Boolean]
    delegate :empty?, to: :order_items

    # Does this order have items?
    #
    # @return [Boolean]
    def has_items?
      total_items > 0
    end

    # Return the number of items in the order?
    #
    # @return [Integer]
    def total_items
      order_items.inject(0) { |t, i| t + i.quantity }
    end

    def self.ransackable_attributes(_auth_object = nil)
      %w[id billing_postcode billing_address1 billing_address2 billing_address3 billing_address4 first_name last_name company email_address phone_number consignment_number status received_at] + _ransackers.keys
    end

    def self.ransackable_associations(_auth_object = nil)
      []
    end
  end
end
