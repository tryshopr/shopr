module Shoppe
  class Order < ActiveRecord::Base
    
    # The associated delivery service
    #
    # @return [Shoppe::DeliveryService]
    belongs_to :delivery_service, :class_name => 'Shoppe::DeliveryService'
    
    # The country where this order is being delivered to (if one has been provided)
    #
    # @return [Shoppe::Country]
    belongs_to :delivery_country, :class_name => 'Shoppe::Country', :foreign_key => 'delivery_country_id'
    
    # The user who marked the order has shipped
    #
    # @return [Shoppe::User]
    belongs_to :shipper, :class_name => 'Shoppe::User', :foreign_key => 'shipped_by'
    
    # Set up a callback for use when an order is shipped
    define_model_callbacks :ship
    
    # Validations
    with_options :if => :separate_delivery_address? do |order|
      order.validates :delivery_name, :presence => true
      order.validates :delivery_address1, :presence => true
      order.validates :delivery_address3, :presence => true
      order.validates :delivery_address4, :presence => true
      order.validates :delivery_postcode, :presence => true
      order.validates :delivery_country, :presence => true
    end
    validate do
      if self.delivery_service && !available_delivery_services.include?(self.delivery_service)
        errors.add :delivery_service_id, "is not suitable for this order"
      end
    end
    
    before_confirmation do
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
    end
    
    # If there isn't a seperate address needed, clear all the fields back to nil
    before_validation do
      unless separate_delivery_address?
        self.delivery_name = nil
        self.delivery_address1 = nil
        self.delivery_address2 = nil
        self.delivery_address3 = nil
        self.delivery_address4 = nil
        self.delivery_postcode = nil
        self.delivery_country = nil
      end
    end
    
    # Create some delivery_ methods which will mimic the billing methods if the order does
    # not need a seperate address.
    [:delivery_name, :delivery_address1, :delivery_address2, :delivery_address3, :delivery_address4, :delivery_postcode, :delivery_country].each do |f|
      define_method(f) do
        separate_delivery_address? ? super() : send(f.to_s.gsub('delivery_', 'billing_'))
      end
    end
    
    # Has this order been shipped?
    #
    # @return [Boolean]
    def shipped?
      !!self.shipped_at?
    end
    
    # The total weight of the order
    #
    # @return [BigDecimal]
    def total_weight
      order_items.inject(BigDecimal(0)) { |t,i| t + i.weight}
    end
    
    # An array of all the delivery services which are suitable for this order in it's
    # current state (based on its current weight)
    #
    # @return [Array] an array of Shoppe::DeliveryService objects
    def available_delivery_services
      @available_delivery_services ||= begin
        delivery_service_prices.map(&:delivery_service).uniq
      end
    end
    
    # An array of all the delivery service prices which can be applied to this order.
    #
    # @return [Array] an array of Shoppe:DeliveryServicePrice objects
    def delivery_service_prices
      @delivery_service_prices ||= begin
        prices = Shoppe::DeliveryServicePrice.joins(:delivery_service).where(:shoppe_delivery_services => {:active => true}).order("`default` desc, price asc").for_weight(total_weight)
        prices = prices.select { |p| p.countries.empty? || p.country?(self.delivery_country) }
        prices
      end
    end

    # The recommended delivery service for this order
    #
    # @return [Shoppe::DeliveryService]
    def delivery_service
      super || available_delivery_services.first
    end
  
    # Return the delivery price for this order in its current state
    #
    # @return [BigDecimal]
    def delivery_service_price
      @delivery_service_price ||= self.delivery_service && self.delivery_service.delivery_service_prices.for_weight(self.total_weight).first
    end
  
    # The price for delivering this order in its current state
    #
    # @return [BigDecimal]
    def delivery_price
      @delivery_price ||= read_attribute(:delivery_price) || delivery_service_price.try(:price) || 0.0
    end
  
    # The cost of delivering this order in its current state
    #
    # @return [BigDecimal]
    def delivery_cost_price
      @delivery_cost_price ||= read_attribute(:delivery_cost_price) || delivery_service_price.try(:cost_price) || 0.0
    end
  
    # The tax amount due for the delivery of this order in its current state
    #
    # @return [BigDecimal]
    def delivery_tax_amount
      @delivery_tax_amount ||= begin
        read_attribute(:delivery_tax_amount) ||
        delivery_price / BigDecimal(100) * delivery_tax_rate ||
        0.0
      end
    end
  
    # The tax rate for the delivery of this order in its current state
    #
    # @return [BigDecimal]
    def delivery_tax_rate
      @delivery_tax_rate ||= begin
        read_attribute(:delivery_tax_rate) ||
        delivery_service_price.try(:tax_rate).try(:rate_for, self) ||
        0.0
      end
    end
  
    # Is the currently assigned delivery service appropriate for this order?
    #
    # @return [Boolean]
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
    #
    # @return [String]
    def courier_tracking_url
      return nil if self.shipped_at.blank? || self.consignment_number.blank?
      @courier_tracking_url ||= self.delivery_service.tracking_url_for(self)
    end
    
    # Mark this order as shipped
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
    
  end
end
