module Shoppe
  class SettingsController < ApplicationController
    
    before_filter { @active_nav = :settings }
    
    def update
      if Shoppe.settings.demo_mode?
        raise Shoppe::Error, "You cannot make changes to settings in demo mode. Sorry about that."
      end
      
      Shoppe::Setting.update_from_hash(params[:settings].permit!)
      redirect_to :settings, :notice => "Settings have been updated successfully."
    end
    
  end
end
