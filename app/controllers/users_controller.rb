class UsersController < ApplicationController

  before_action :require_guest, only: [:new, :create]
  before_action :require_user, :profile_owner, only: [:update]
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
      session[:user_id] = @user.id
      flash[:success_notice] = 'User has been created. You are logged in.'
      redirect_to '/'
    else
      render :json => {:error => @user.errors.full_messages}, status: 422
    end
  end

  def update
    @user = User.find(params[:id])

    if params[:avatar]

      uploader = Uploader::AvatarUploader.new(@user, params[:avatar])

      unless uploader.check_type
        return render :json => {:error => ['File has no valid type (image required)']}, status: 422
      end

      unless uploader.check_size
        return render :json => {:error => ['File is too large (Maximum size: 500 kb)']}, status: 422
      end

      if uploader.save
        params[:avatar] = "/assets/images/avatars/#{params[:id]}.jpg"
      else
        params[:avatar] = nil
      end

    end

    if @user.update(update_params)
      Rails.cache.delete("/user/#{params[:id]}/info")

      render :json => {
          :message => 'User has been updated successfully',
          data: {
              :username => @user.username,
              :email => @user.email,
              :avatar => params[:avatar]
          }
      }


    else
      render :json => {:error => @user.errors.full_messages}, status: 422
    end
  end


  private
  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

  def update_params
    params.permit(:username, :email, :avatar)
  end

end
