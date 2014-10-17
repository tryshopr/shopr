module Shoppe
  class SessionsController < Shoppe::ApplicationController

    layout 'shoppe/sub'
    skip_before_filter :login_required, :only => [:new, :create, :reset]

    def create
      if user = Shoppe::User.authenticate(params[:email_address], params[:password])
        session[:shoppe_user_id] = user.id
        redirect_to :orders
      else
        flash.now[:alert] =  t('shoppe.sessions.create_alert')
        render :action => "new"
      end
    end

    def destroy
      session[:shoppe_user_id] = nil
      redirect_to :login
    end

    def reset

      if request.post?
        if user = Shoppe::User.find_by_email_address(params[:email_address])
          user.reset_password!
          redirect_to login_path(:email_address => params[:email_address]), :notice => t('shoppe.sessions.reset_notice', email_address: user.email_address)
        else
          flash.now[:alert] = t('shoppe.sessions.reset_alert')
        end
      end
    end
  end
end
