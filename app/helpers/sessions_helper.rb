module SessionsHelper
  def user_with_session
    return unless (session_user_id = session[:user_id])
    fetch_cache(User, session_user_id)
  end

  def user_with_cookie
    return unless (cookie_user_id = cookies.signed[:user_id])
    user = fetch_cache(User, cookie_user_id)
    return unless user && user.authenticated?(:remember, cookies[:remember_token])
    user
  end

  # Logs in the given user.
  # @param [User] user
  def log_in(user)
    session[:user_id] = user.id
    flash[:info_notice] = 'You have been logged in as: ' + user.username
  end

  # @param [User] user
  def log_in_and_redirect_with_back(user)
    log_in user
    redirect_to session.delete(:prev_url) || root_url
  end

  # Remembers a user in a persistent session and save remember_token in DB
  # @param [User] user
  def remember(user)
    user.remember # message token and save its hash in the DB
    cookies.permanent.signed[:user_id] = user.id # message cookie with user id
    cookies.permanent[:remember_token] = user.remember_token # message user's token as cookie to check in further
  end

  # destroy session and clear current_user
  def log_out
    forget(@current_user)
    session.delete(:user_id)
    @current_user = nil
  end

  # Forgets a persistent session.
  # @param [User] user
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    current_user.present?
  end
end
