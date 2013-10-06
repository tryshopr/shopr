class Shoppe::OrderMailer < ActionMailer::Base
  
  default :from => "#{Shoppe.config[:store_name]} <#{Shoppe.config[:email_address]}>"
  
  def received(order)
    @order = order
    mail :to => order.email_address, :subject => I18n.t('shoppe.order_mailer.received.subject', :default => "Order Confirmation")
  end
  
  def accepted(order)
    @order = order
    mail :to => order.email_address, :subject => I18n.t('shoppe.order_mailer.received.accepted', :default => "Order Accepted")
  end
  
  def rejected(order)
    @order = order
    mail :to => order.email_address, :subject => I18n.t('shoppe.order_mailer.received.rejected', :default => "Order Rejected")
  end
  
  def shipped(order)
    @order = order
    mail :to => order.email_address, :subject => I18n.t('shoppe.order_mailer.received.shipped', :default => "Order Shipped")
  end
  
end
