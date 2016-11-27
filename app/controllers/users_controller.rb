class UsersController < ApplicationController
  include UsersHelper

  before_action :require_guest, only: [:new, :create]
  before_action :require_user, :profile_owner, only: [:update, :destroy]
  before_action Throttle::Interval::RequestInterval, only: [:create, :update]

  def show
    @user = Rails.cache.fetch("/user/#{params[:id]}/info") do
      User.left_outer_joins(:recent_lessons, :profile).select_profile_attr.find(params[:id])
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if verify_recaptcha(model: @user) && @user.save
      @user.send_activation_email
      flash[:super_info_notice] = "Please check your email (#{user_params[:email]}) to activate your account. Email must come during several minutes."
      redirect_to '/'
    else
      render :json => {:error => @user.errors.full_messages}, status: 422
    end
  end

  def update
    @user = User.find(params[:id])
    file = FileHelper::Uploader::AvatarUploader.new(@user, params[:user][:avatar])
    unless params[:user][:avatar].nil?
      if file.valid?
        params[:user][:avatar] = file.path
      else
        return render :json => {:error => [file.error]}, status: 422
      end
    end

    if @user.update(update_params) && file.save
      success_update
    else
      fail_update
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
                                 profile_attributes: [:facebook, :twitter, :website, :location, :about])
  end

end
