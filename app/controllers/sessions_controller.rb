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
      return user_not_found_message
    end

    if user.facebook_id
      return render :json => 'You can access Facebook account only with facebook login button', status: 403
    end

    if user.authenticate(params[:session][:password])
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_to root_url
      else
        return render :json => 'Account not activated. Check your email and confirm it', status: 404
      end
    else
      user_not_found_message
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to '/'
  end

  private

  def user_not_found_message
    render :json => 'User with this credentials not found', status: 404
  end
end
