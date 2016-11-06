class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper
  helper_method :current_user, :it_is_current_user


  # if no session[:user_id] - check cookie and log_in user with its value (id of the user)
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(:remember, cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  def require_user
    unless current_user
      flash[:danger_notice] = 'You need login to go there'
      redirect_to root_url
    end

  end

  def require_guest
    if current_user
      flash[:danger_notice] = 'Authorized user cannot be there'
      redirect_to root_url
    end
  end

  def it_is_current_user(user)

    if current_user&&user
      current_user.id == user.id
    end

  end

  def profile_owner
    unless current_user.id == params[:id].to_i
      if request.xhr?
        render :json => {:error => ['Access denied']}, status: 403
      else
        flash[:danger_notice] = 'Access denied'
        redirect_to root_url
      end

    end
  end

end
