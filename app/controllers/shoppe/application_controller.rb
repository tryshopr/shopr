module Shoppe
  class ApplicationController < ActionController::Base
    
    before_filter :login_required

    private

    def login_required
      unless logged_in?
        redirect_to login_path
      end
    end

    def logged_in?
      current_user.is_a?(User)
    end

    def current_user
      @current_user ||= login_from_session || :false
    end

    def login_from_session
      if session[:shoppe_user_id]
        @user = User.find_by_id(session[:shoppe_user_id])
      end
    end

    helper_method :current_user
    
    
  end
end
