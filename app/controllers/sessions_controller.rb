class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  before_action Throttle::Interval::SessionLocker, only: [:create]
  before_action :require_guest, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    unless user
      return error_message(['User with this credentials not found'], 404)
    end

    if user.facebook_id

      return error_message(['You can access Facebook account only with facebook login button'], 403)
    end

    if user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to root_url
      else

        return error_message(['Account not activated. Check your email and confirm it'], 404)
      end
    else
      error_message(['User with this credentials not found'], 404)
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to '/'
  end
end
