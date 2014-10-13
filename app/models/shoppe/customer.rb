module Shoppe
  class Customer < ActiveRecord::Base

    self.table_name = "shoppe_customers"

    has_secure_password

    # Validations
    validates :email, :presence => true, :uniqueness => true, :format => {:with => /\A\b[A-Z0-9\.\_\%\-\+]+@(?:[A-Z0-9\-]+\.)+[A-Z]{2,6}\b\z/i}
    validates :phone, :presence => true, :format => {:with => /\A[\d\ \-x\(\)]{7,}\z/}

    # All customers ordered by their ID desending
    scope :ordered, -> { order(:id => :desc)}


    # The name of the customer in the format of "Company (First Last)" or if they don't have
    # company specified, just "First Last".
    #
    # @return [String]
    def name
      company.blank? ? full_name : "#{company} (#{full_name})"
    end

    # The full name of the customer created by concatinting the first & last name
    #
    # @return [String]
    def full_name
      "#{first_name} #{last_name}"
    end

    # Attempt to authenticate a customer based on email & password. Returns the 
    # user if successful otherwise returns false.
    #
    # @param email [String]
    # @param paassword [String]
    # @return [Shoppe::Customer]
    def self.authenticate(email, password)
      customer = self.where(:email => email).first
      return false if customer.nil?
      return false unless customer.authenticate(password)
      customer
    end


    def self.ransackable_attributes(auth_object = nil) 
      ["id", "first_name", "last_name", "company", "email", "phone", "mobile"] + _ransackers.keys
    end
  
    def self.ransackable_associations(auth_object = nil)
      []
    end

  end
end