# Common controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include CustomHelper::Cache
  helper_method :current_user, :current_user?

  after_action :check_live_id

  # if no session[:user_id] - check cookie and
  # log_in user with its value (id of the user)
  # @return [User]
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= fetch_cache(User, user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = fetch_cache(User, user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user ||= user
      end
    end
  end

  # require auth user
  def authenticate_user!
    return if current_user.present?
    respond_to do |format|
      format.any(:js, :json) { error_message(['You need login to go there'], 403) }
      format.html do
        session[:prev_url] = request.fullpath
        flash[:danger_notice] = 'You need to login to go there'
        redirect_to login_url
      end
    end
  end

  # check if user is guest (not auth)
  def require_guest
    return if current_user.blank?
    flash[:danger_notice] = 'Access denied for authorized user'
    redirect_to root_url
  end

  def profile_owner
    return if current_user.friendly_id == params[:id]
    fail_response(['Access denied'], 403)
  end

  # check if passed user equals current user
  # @param [User] user
  def current_user?(user)
    current_user.try(:id) == user.id
  end

  # check if current user is "creator" of the resource
  # @param [ActiveRecord] resource
  # @param [String] key
  def owner?(resource, key = 'author_id')
    current_user.id == resource.send(key)
  end

  # check if auth user is a teacher
  def require_teacher
    return if current_user.role? :teacher
    fail_response(['You are not a teacher'], 403)
  end

  # mime based error response
  # @param [Object] errors
  # @param [Object] status
  def fail_response(errors, status)
    respond_to do |format|
      # we should avoid "any(:js, :json)" if we want to get
      # responses with content-type 'application/json'
      # from the server and no 'text/javascript' or whatever else
      # that can cause problems while handle response
      # because in case of 'text/javascript'
      # response we will get stringify version of json response
      format.json { error_message(errors, status) }
      format.html do
        flash[:danger_notice] = errors.first
        redirect_to root_url
      end
    end
  end

  # json format error response
  # @param [Array] errors - array of errors
  # @param [Integer] status - http code of error
  def error_message(errors, status)
    render json: { errors: errors }, status: status
  end

  private

  # set cookie for action cable authentication
  def check_live_id
    if current_user.present?
      cookies.signed[:live_user_id] ||= @current_user.id
    else
      cookies.delete :live_user_id
    end
  end
end
