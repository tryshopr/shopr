module Shoppe
  class Order < ActiveRecord::Base
    
    # An array of all the available statuses for an order
    STATUSES = ['building', 'confirming', 'received', 'accepted', 'rejected', 'shipped']
  
    belongs_to :accepter, :class_name => 'Shoppe::User', :foreign_key => 'accepted_by'
    belongs_to :rejecter, :class_name => 'Shoppe::User', :foreign_key => 'rejected_by'
    belongs_to :shipper, :class_name => 'Shoppe::User', :foreign_key => 'shipped_by'
    
    # Validations
    validates :status, :inclusion => {:in => STATUSES}
    
    before_validation do
      if self.status.blank?
        self.status = 'building'
      end
    end
    
    # Scopes
    scope :received, -> {where("received_at is not null")}
    scope :pending, -> { where(:status => 'received') }
    scope :ordered, -> { order('id desc')}
    
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
  
    # Has the order been received?
    def received?
      !!self.received_at?
    end
  
    
  end
end
