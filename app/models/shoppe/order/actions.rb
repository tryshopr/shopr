module Shoppe
  class Order < ActiveRecord::Base
    
    # These additional callbacks allow for applications to hook into other
    # parts of the order lifecycle.
    define_model_callbacks :confirmation, :acceptance, :rejection
  
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
      no_stock_of = self.order_items.select(&:validate_stock_levels)
      unless no_stock_of.empty?
        raise Shoppe::Errors::InsufficientStockToFulfil, :order => self, :out_of_stock_items => no_stock_of
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
    
  end
end
