class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  before_action Throttle::Interval::SessionLocker, only: [:create]
  before_action :require_guest, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to root_url
      else
        render :json => 'Account not activated. Check your email and confirm it', status: 404
      end
    else
      render :json => 'User with this credentials not found', status: 404
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to '/'
  end
end
