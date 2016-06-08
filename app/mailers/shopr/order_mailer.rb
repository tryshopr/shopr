module Shopr
  class OrderMailer < ActionMailer::Base
    def received(order)
      @order = order
      mail from: Shopr.settings.outbound_email_address, to: order.email_address, subject: I18n.t('shopr.order_mailer.received.subject', default: 'Order Confirmation')
    end

    def accepted(order)
      @order = order
      mail from: Shopr.settings.outbound_email_address, to: order.email_address, subject: I18n.t('shopr.order_mailer.received.accepted', default: 'Order Accepted')
    end

    def rejected(order)
      @order = order
      mail from: Shopr.settings.outbound_email_address, to: order.email_address, subject: I18n.t('shopr.order_mailer.received.rejected', default: 'Order Rejected')
    end

    def shipped(order)
      @order = order
      mail from: Shopr.settings.outbound_email_address, to: order.email_address, subject: I18n.t('shopr.order_mailer.received.shipped', default: 'Order Shipped')
    end
  end
end
