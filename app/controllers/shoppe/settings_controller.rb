module Shoppe
  class SettingsController < ApplicationController
    
    before_filter { @active_nav = :settings }
    
    def update
      if Shoppe.settings.demo_mode?
        raise Shoppe::Error, I18n.t(:settings_not_in_demo)
      end
      
      Shoppe::Setting.update_from_hash(params[:settings].permit!)
      redirect_to :settings, :notice => confirm_updated(:settings)
    end
    
  end
end
