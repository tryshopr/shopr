module Shoppe
  class UserMailer < ActionMailer::Base
    default :from => "#{Shoppe.config[:store_name]} <#{Shoppe.config[:email_address]}>"

    def new_password(user)
      @user = user
      mail :to => user.email_address, :subject => "Your new Shoppe password"
    end
  end
end
