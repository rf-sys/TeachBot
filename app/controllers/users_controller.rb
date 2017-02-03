# CRUD for 'User' model
class UsersController < ApplicationController
  include Services::UseCases::User::UpdateUserService
  include UsersHelper
  before_action :require_guest, only: [:new, :create]
  before_action :require_user, :profile_owner, only: [:edit, :update, :destroy]
  before_action

  def show
    @user = User.friendly.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if verify_recaptcha(model: @user) && @user.save
      @user.send_activation_email
      flash[:super_info_notice] = activate_account_message(@user.email)
      redirect_to '/'
    else
      error_message(@user.errors.full_messages, 422)
    end
  end

  def edit
    @user = User.friendly.find(params[:id])
  end

  def update
    user = User.friendly.find(params[:id])
    update_user_service = UpdateUser.new(Repositories::UserRepository, self)
    update_user_service.update(user, update_params)
  end

  def destroy
    @user = User.friendly.find(params[:id])
    @user.destroy
    session[:user_id] = nil
    flash[:success_notice] = 'User has been deleted.'
    redirect_to '/'
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def update_params
    params.require(:user).permit(:username, :email, :avatar,
                                 profile_attributes: profile_attributes)
  end

  def profile_attributes
    [:facebook, :twitter, :website, :location, :about, :id]
  end

  def activate_account_message(email)
    I18n.t 'custom.models.user.messages.need_activate_account', email: email
  end
end
