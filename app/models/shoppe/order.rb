module Shoppe
  class Order < ActiveRecord::Base

    # Set the table name
    self.table_name = 'shoppe_orders'
  
    # An array of all the available statuses for an order
    STATUSES = ['building', 'confirming', 'received', 'accepted', 'rejected', 'shipped']
  
    # Order's implement a key value store for storing arbitary properties which 
    # may be useful (for example payment configuraiton)
    key_value_store :properties
  
    # These additional callbacks allow for applications to hook into other
    # parts of the order lifecycle.
    define_model_callbacks :confirmation, :payment, :acceptance, :rejection, :ship
  
    # Relationships
    belongs_to :delivery_service, :class_name => 'Shoppe::DeliveryService'
    belongs_to :country, :class_name => 'Shoppe::Country'
    belongs_to :accepter, :class_name => 'Shoppe::User', :foreign_key => 'accepted_by'
    belongs_to :rejecter, :class_name => 'Shoppe::User', :foreign_key => 'rejected_by'
    belongs_to :shipper, :class_name => 'Shoppe::User', :foreign_key => 'shipped_by'
    has_many :order_items, :dependent => :destroy, :class_name => 'Shoppe::OrderItem'
    has_many :products, :through => :order_items, :class_name => 'Shoppe::Product'
  
    # Validations
    validates :token, :presence => true
    validates :status, :inclusion => {:in => STATUSES}
    with_options :if => Proc.new { |o| !o.building? } do |order|
      order.validates :first_name, :presence => true
      order.validates :last_name, :presence => true
      order.validates :address1, :presence => true
      order.validates :address3, :presence => true
      order.validates :address4, :presence => true
      order.validates :postcode, :presence => true
      order.validates :country, :presence => true
      order.validates :email_address, :format => {:with => /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i}
      order.validates :phone_number, :format => {:with => /\A[\d\ \-x]{7,}\z/}
    end
    validate do
      unless available_delivery_services.include?(self.delivery_service)
        errors.add :delivery_service_id, "is not suitable for this order"
      end
    end
  
    # Scopes
    scope :received, -> {where("received_at is not null")}
    scope :pending, -> { where(:status => 'received') }
    scope :ordered, -> { order('id desc')}
  
    # Set some defaults
    before_validation do
      self.status = 'building' if self.status.blank?
      self.token = SecureRandom.uuid if self.token.blank?
    end
  
    # Is this order still being built by the user?
    def building?
      self.status == 'building'
    end
  
    # Is this order in the user confirmation step?
    def confirming?
      self.status == 'confirming'
    end
  
    # Has this order been rejected?
    def rejected?
      !!self.rejected_at
    end
  
    # Has this order been accepted?
    def accepted?
      !!self.accepted_at
    end
  
    # Has this order been shipped?
    def shipped?
      !!self.shipped_at?
    end
  
    # Has the order been received?
    def received?
      !!self.received_at?
    end
  
    # The order number
    def number
      id.to_s.rjust(6, '0')
    end
  
    # The length of time the customer spent building the order before submitting it to us.
    # The time from first item in basket to received.
    def build_time
      return nil if self.received_at.blank?
      self.created_at - self.received_at
    end
  
    # The name of the customer
    def customer_name
      company.blank? ? "#{first_name} #{last_name}" : "#{company} (#{first_name} #{last_name})"
    end
  
    # Is this order empty? (i.e. doesn't have any items associated with it)
    def empty?
      order_items.empty?
    end
  
    # Does this order have items?
    def has_items?
      total_items > 0
    end
  
    # Return the number of items in the order?
    def total_items
      @total_items ||= order_items.inject(0) { |t,i| t + i.quantity }
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
  
    # The total of the order including tax in pence
    def total_in_pence
      (total * BigDecimal(100)).to_i
    end
  
    # The total weight of the order
    def total_weight
      order_items.inject(BigDecimal(0)) { |t,i| t + i.weight}
    end
  
    # An array of all the delivery service prices which can be applied to this order.
    def delivery_service_prices
      @delivery_service_prices ||= begin
        prices = Shoppe::DeliveryServicePrice.joins(:delivery_service).where(:shoppe_delivery_services => {:active => true}).order("`default` desc, price asc").for_weight(total_weight)
        prices = prices.select { |p| p.countries.empty? || p.country?(self.country) }
        prices
      end
    end
  
    # An array of all the delivery services which are suitable for this order in it's
    # current state (based on its current weight)
    def available_delivery_services
      @available_delivery_services ||= begin
        delivery_service_prices.map(&:delivery_service).uniq
      end
    end
  
    # The recommended delivery service for this order
    def delivery_service
      super || available_delivery_services.first
    end
  
    # Return the delivery price for this order in its current state
    def delivery_service_price
      @delivery_service_price ||= self.delivery_service && self.delivery_service.delivery_service_prices.for_weight(self.total_weight).first
    end
  
    # The price for delivering this order in its current state
    def delivery_price
      @delivery_price ||= read_attribute(:delivery_price) || delivery_service_price.try(:price) || 0.0
    end
  
    # The cost of delivering this order in its current state
    def delivery_cost_price
      @delivery_cost_price ||= read_attribute(:delivery_cost_price) || delivery_service_price.try(:cost_price) || 0.0
    end
  
    # The tax amount due for the delivery of this order in its current state
    def delivery_tax_amount
      @delivery_tax_amount ||= begin
        read_attribute(:delivery_tax_amount) ||
        delivery_price / BigDecimal(100) * delivery_tax_rate ||
        0.0
      end
    end
  
    # The tax rate for the delivery of this order in its current state
    def delivery_tax_rate
      @delivery_tax_rate ||= begin
        read_attribute(:delivery_tax_rate) ||
        delivery_service_price.try(:tax_rate).try(:rate_for, self) ||
        0.0
      end
    end
  
    # Is the currently assigned delivery service appropriate for this order?
    def valid_delivery_service?
      self.delivery_service && self.available_delivery_services.include?(self.delivery_service)
    end
  
    # Remove the associated delivery service if it's invalid
    def remove_delivery_service_if_invalid
      unless self.valid_delivery_service?
        self.delivery_service = nil
        self.save
      end
    end
  
    # The URL which can be used to track the delivery of this order
    def courier_tracking_url
      return nil if self.shipped_at.blank? || self.consignment_number.blank?
      @courier_tracking_url ||= self.delivery_service.tracking_url_for(self.consignment_number)
    end
  
    # Has this order been fully paid for?
    def paid?
      !paid_at.blank?
    end
  
    # This method is called by the customer when they submit their details in the first step of
    # the checkout process. It will update the status to 'confirmed' as well as updating their 
    # details. Any issues with validation will cause false to be returned otherwise true. Any
    # more serious issues will be raised as exceptions.
    def proceed_to_confirm(params = {})
      self.status = 'confirming'
      if self.update(params)
        true
      else
        false
      end
    end
  
    # This method will confirm the order If there are any issues with  the order an exception 
    # should be raised.
    def confirm!
    
      # Ensure that we have the stock to fulfil this order at the current time. We may have had it when
      # it was placed int he basket and if we don't now, we should let the user know so they can
      # rethink.
      no_stock_of = self.order_items.select(&:validate_stock_levels)
      unless no_stock_of.empty?
        raise Shoppe::Errors::InsufficientStockToFulfil, :order => self, :out_of_stock_items => no_stock_of
      end
    
      # Ensure that before we confirm the order that the delivery service which has been selected
      # is appropritae for the contents of the order.
      unless self.valid_delivery_service?
        raise Shoppe::Errors::InappropriateDeliveryService, :order => self
      end
    
      # Store the delivery prices with the order
      if self.delivery_service
        write_attribute :delivery_service_id, self.delivery_service.id
        write_attribute :delivery_price, self.delivery_price
        write_attribute :delivery_cost_price, self.delivery_cost_price
        write_attribute :delivery_tax_amount, self.delivery_tax_amount
        write_attribute :delivery_tax_rate, self.delivery_tax_rate
      end
      
      run_callbacks :confirmation do
        # If we have successfully charged the card (i.e. no exception) we can go ahead and mark this
        # order as 'received' which means it can be accepted by staff.
        self.status = 'received'
        self.received_at = Time.now
        self.save!

        self.order_items.each(&:confirm!)

        # Send an email to the customer
        Shoppe::OrderMailer.received(self).deliver
      end
    
      # We're all good.
      true
    end
  
    # This method will mark an order as paid.
    def pay!(reference, method)
      run_callbacks :payment do
        self.paid_at = Time.now.utc
        self.payment_reference = reference
        self.payment_method = method
        self.save!
      end
    end
  
    # This method will accept the this order. It is called by a user (which is the only
    # parameter).
    def accept!(user)
      run_callbacks :acceptance do
        self.accepted_at = Time.now
        self.accepted_by = user.id
        self.status = 'accepted'
        self.save!
        self.order_items.each(&:accept!)
        Shoppe::OrderMailer.accepted(self).deliver
      end
    end
  
    # This method will reject the order. It is called by a user (which is the only parameter).
    def reject!(user)
      run_callbacks :rejection do
        self.rejected_at = Time.now
        self.rejected_by = user.id
        self.status = 'rejected'
        self.save!
        self.order_items.each(&:reject!)
        Shoppe::OrderMailer.rejected(self).deliver
      end
    end
  
    # This method will mark an order as shipped and store the given consignment number with the
    # order for use later in tracking.
    def ship!(user, consignment_number)
      run_callbacks :ship do
        self.shipped_at = Time.now
        self.shipped_by = user.id
        self.status = 'shipped'
        self.consignment_number = consignment_number
        self.save!
        Shoppe::OrderMailer.shipped(self).deliver
      end
    end
  
    # Specify which attributes can be searched
    def self.ransackable_attributes(auth_object = nil) 
      ["id", "postcode", "address1", "address2", "address3", "address4", "first_name", "last_name", "company", "email_address", "phone_number", "consignment_number", "status", "received_at"] + _ransackers.keys
    end
  
    # Specify which associations can be searched
    def self.ransackable_associations(auth_object = nil)
      ['products']
    end
  
  end
end
