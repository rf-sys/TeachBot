class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  before_action Throttle::Interval::SessionLocker, only: [:create]
  before_action :require_guest, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.find_by_email(params[:session][:email])

    if @user && @user.authenticate(params[:session][:password])
      session[:user_id] = @user.id
      flash[:info_notice] = 'You have been logged in as: ' + @user.username
      redirect_to '/'
    else
      render :json => 'User with this credentials not found', status: 404
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to '/'
  end


end
