module Shopr
  class SettingsController < ApplicationController
    before_filter { @active_nav = :settings }

    def update
      if Shopr.settings.demo_mode?
        fail Shopr::Error, t('shopr.settings.demo_mode_error')
      end

      Shopr::Setting.update_from_hash(params[:settings].permit!)
      redirect_to :settings, notice: t('shopr.settings.update_notice')
    end
  end
end
