# CRUD for 'User' model
class UsersController < ApplicationController
  include UsersHelper
  before_action :require_guest, only: [:new, :create]
  before_action :require_user, :profile_owner, only: [:edit, :update, :destroy]

  def show
    @user = get_from_cache(User, params[:id])
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
    @user = get_from_cache(User, params[:id])
  end

  def update
    @user = User.find(params[:id])
    form = UpdateForm.new(@user, update_params)
    updating = Updating.new(form)

    if form.valid? && updating.update
      success_update
    else
      error_message(form.errors, 422)
    end
  end

  def destroy
    @user = User.find(params[:id])
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
