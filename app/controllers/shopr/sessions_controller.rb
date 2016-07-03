module Shopr
  class SessionsController < Shopr::ApplicationController
    layout 'shopr/sub'
    skip_before_action :login_required, only: [:new, :create]

    def create
      if user = Shopr::User.authenticate(params[:email_address], params[:password])
        session[:shopr_user_id] = user.id
        redirect_to :orders
      else
        flash.now[:alert] = t('shopr.sessions.create_alert')
        render action: 'new'
      end
    end

    def destroy
      session[:shopr_user_id] = nil
      redirect_to :login
    end
  end
end
