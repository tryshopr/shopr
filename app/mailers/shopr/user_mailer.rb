module Shopr
  class UserMailer < ActionMailer::Base
    def new_password(user)
      @user = user
      mail from: Shopr.settings.outbound_email_address, to: user.email_address, subject: 'Your new Shopr password'
    end
  end
end
