module SessionsHelper
  # Logs in the given user.
  def log_in(user)
    session[:user_id] = user.id
    flash[:info_notice] = 'You have been logged in as: ' + user.username
  end

  # Remembers a user in a persistent session and save remember_token in DB
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
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !@current_user.nil?
  end
end
