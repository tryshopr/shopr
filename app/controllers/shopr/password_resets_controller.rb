module Shopr
  class PasswordResetsController < Shopr::ApplicationController
    layout 'shopr/sub'
    skip_before_filter :login_required

    def create
      if user = Shopr::User.find_by_email_address(params[:email_address])
        user.reset_password!
      end
      redirect_to login_path(email_address: params[:email_address]), notice: t('shopr.sessions.reset_notice', email_address: params[:email_address])
    end
  end
end
