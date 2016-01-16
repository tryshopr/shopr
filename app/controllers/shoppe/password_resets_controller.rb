module Shoppe
  class PasswordResetsController < Shoppe::ApplicationController

    layout 'shoppe/sub'
    skip_before_filter :login_required

    def create
      if user = Shoppe::User.find_by_email_address(params[:email_address])
        user.reset_password!
        redirect_to login_path(:email_address => params[:email_address]), :notice => t('shoppe.sessions.reset_notice', email_address: user.email_address)
      else
        flash.now[:alert] = t('shoppe.sessions.reset_alert')
        render :new
      end
    end

  end
end
