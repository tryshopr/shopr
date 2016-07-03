module Shopr
  class ApplicationController < ActionController::Base
    protect_from_forgery

    # before_action :login_required
    before_action :authenticate_user!

    rescue_from ActiveRecord::DeleteRestrictionError do |e|
      redirect_to request.referer || root_path, alert: e.message
    end

    rescue_from Shopr::Error do |e|
      @exception = e
      render layout: 'shopr/sub', template: 'shopr/shared/error'
    end

    private

    # def login_required
    #   if Shopr.settings.demo_mode?
    #     current_user = User.first
    #   elsif
    #     :authenticate_user!
    #   end
    # end

    helper_method :current_user, :logged_in?
  end
end
