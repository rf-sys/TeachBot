# Authentication service
class SessionsController < ApplicationController
  before_action :authenticate_user!, only: [:destroy]
  before_action :session_locker, :set_user, only: [:create]
  before_action :require_guest, except: [:destroy]

  def new
    @user = User.new
  end

  def create
    if @user.authenticate(params[:session][:password])
      if @user.activated?
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        return log_in_and_redirect_with_back(@user)
      end
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
    error_message([user_not_found], 404) if @user.blank?
  end

  def session_locker
    Services::Throttle::RequestLocker.new(self, time: 1 * 60, attempts: 5)
  rescue StandardError => e
    fail_response([e.message + ' Try in 1 minute'], 403)
  end

  def user_not_found
    I18n.t 'custom.models.user.messages.not_found'
  end

  def account_not_activated
    I18n.t 'custom.models.user.messages.account_not_activated'
  end
end
