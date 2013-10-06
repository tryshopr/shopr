class Shoppe::OrderMailer < ActionMailer::Base
  
  default :from => "#{Shoppe.config[:store_name]} <#{Shoppe.config[:email_address]}>"
  
  def received(order)
    @order = order
    mail :to => order.email_address, :subject => "Order Confirmation"
  end
  
  def accepted(order)
    @order = order
    mail :to => order.email_address, :subject => "Order Accepted"
  end
  
  def rejected(order)
    @order = order
    mail :to => order.email_address, :subject => "Order Rejected"
  end
  
  def shipped(order)
    @order = order
    mail :to => order.email_address, :subject => "Order Shipped"
  end
  
end
