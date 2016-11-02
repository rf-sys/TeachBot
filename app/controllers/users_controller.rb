class UsersController < ApplicationController
  include UsersHelper

  before_action :require_guest, only: [:new, :create]
  before_action :require_user, :profile_owner, only: [:update, :destroy]
  before_action Throttle::Interval::SignUp, only: [:create]

  def show
    @user = Rails.cache.fetch("/user/#{params[:id]}/info") do
      User.select(:id, :username, :email, :avatar, :updated_at).find(params[:id])
    end
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.signup_mail(@user).deliver_now
      session[:user_id] = @user.id
      flash[:success_notice] = 'User has been created. You are logged in.'
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
      Rails.cache.delete("/user/#{params[:id]}/info")
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
    params.require(:user).permit(:username, :email, :avatar)
  end

end
