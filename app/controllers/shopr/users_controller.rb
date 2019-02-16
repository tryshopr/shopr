module Shopr
  class UsersController < Shopr::ApplicationController
    before_action { @active_nav = :users }
    before_action { params[:id] && @user = Shopr::User.find(params[:id]) }
    before_action(only: %i[create update destroy]) do
      if Shopr.settings.demo_mode?
        raise Shopr::Error, t('shopr.users.demo_mode_error')
      end
    end

    def index
      @users = Shopr::User.all
    end

    def new
      @user = Shopr::User.new
    end

    def create
      @user = Shopr::User.new(safe_params)
      if @user.save
        redirect_to :users, flash: { notice: t('shopr.users.create_notice') }
      else
        render action: 'new'
      end
    end

    def edit; end

    def update
      if @user.update(safe_params)
        redirect_to [:edit, @user], flash: { notice: t('shopr.users.update_notice') }
      else
        render action: 'edit'
      end
    end

    def destroy
      raise Shopr::Error, t('shopr.users.self_remove_error') if @user == current_user

      @user.destroy
      redirect_to :users, flash: { notice: t('shopr.users.destroy_notice') }
    end

    private

    def safe_params
      params[:user].permit(:first_name, :last_name, :email_address, :password, :password_confirmation)
    end
  end
end
