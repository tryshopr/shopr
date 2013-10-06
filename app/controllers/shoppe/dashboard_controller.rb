class Shoppe::DashboardController < Shoppe::ApplicationController
  
  def home
    redirect_to :orders
  end
  
end
