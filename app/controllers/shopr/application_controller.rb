module Shopr
  class ApplicationController < ActionController::Base
    protect_from_forgery prepend: true

    before_action :authenticate_user!

    rescue_from ActiveRecord::DeleteRestrictionError do |e|
      redirect_to request.referer || root_path, alert: e.message
    end

    rescue_from Shopr::Error do |e|
      @exception = e
      render layout: 'shopr/sub', template: 'shopr/shared/error'
    end
  end
end
