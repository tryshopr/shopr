class Shoppe::SessionsController < Shoppe::ApplicationController
  layout 'shoppe/sub'
  skip_before_filter :login_required, :only => [:new, :create]
  
  def create
    if user = Shoppe::User.authenticate(params[:email_address], params[:password])
      session[:shoppe_user_id] = user.id
      redirect_to :products
    else
      flash.now[:alert] = "The email address and/or password you have entered is invalid. Please check and try again."
      render :action => "new"
    end
  end
  
  def destroy
    session[:shoppe_user_id] = nil
    redirect_to :login
  end
end
