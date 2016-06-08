module Shopr
  class DashboardController < Shopr::ApplicationController
    def home
      redirect_to :orders
    end
  end
end
