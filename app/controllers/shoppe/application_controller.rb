module Shoppe
  class ApplicationController < ActionController::Base
    
    # Require that a user is logged in for all parts of the Shoppe admin
    # interface.
    before_filter :login_required
    
    rescue_from ActiveRecord::DeleteRestrictionError do |e|
      redirect_to request.referer || root_path, :alert => e.message
    end
    
    rescue_from Shoppe::Error do |e|
      @exception = e
      render :layout => 'shoppe/sub', :template => 'shoppe/shared/error'
    end

    private

    # If not logged in, redirect users to the login page. This should be
    # used in a before filter.
    def login_required
      unless logged_in?
        redirect_to login_path
      end
    end

    # Is there a user currently logged in?
    def logged_in?
      current_user.is_a?(User)
    end
    
    # Returns the currently logged in user
    def current_user
      @current_user ||= login_from_session || login_with_demo_mdoe || :false
    end

    # Attempt to find a user based on the value stored in the local session
    def login_from_session
      if session[:shoppe_user_id]
        @user = User.find_by_id(session[:shoppe_user_id])
      end
    end
    
    # Attempt to login using the demo mode
    def login_with_demo_mdoe
      if Shoppe.config[:demo_mode]
        @user = User.first
      end
    end
    
    # Expose a current_user and logged_in? as helpers to views
    helper_method :current_user, :logged_in?
    
  end
end
