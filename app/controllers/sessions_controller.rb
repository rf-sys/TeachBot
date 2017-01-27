# Authentication service
class SessionsController < ApplicationController
  before_action :require_user, only: [:destroy]
  before_action :session_locker, :set_user, only: [:create]
  before_action :require_guest, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user.authenticate(params[:session][:password])
      return log_in_and_redirect(@user) if @user.activated?
      error_message([account_not_activated], 404)
    else
      error_message([user_not_found], 404)
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to '/'
  end

  private

  def set_user
    @user = User.find_by(email: params[:session][:email].downcase, uid: nil)
    error_message([user_not_found], 404) unless @user.present?
  end

  def session_locker
    Throttle::Interval::SessionLocker.run(self, 'login_interval', interval: 1)
  end

  def user_not_found
    I18n.t 'custom.models.user.messages.not_found'
  end

  def account_not_activated
    I18n.t 'custom.models.user.messages.account_not_activated'
  end

  def log_in_and_redirect(user)
    log_in user
    params[:session][:remember_me] == '1' ? remember(user) : forget(user)
    redirect_to root_url
  end
end
