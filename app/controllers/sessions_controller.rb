class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  before_action Throttle::Interval::SessionLocker, only: [:create]
  before_action :require_guest, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      remember user
      redirect_to '/'
    else
      render :json => 'User with this credentials not found', status: 404
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to '/'
  end
end
