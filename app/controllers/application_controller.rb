class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :it_is_current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    unless current_user
      flash[:info_danger] = 'You need login to go there'
      redirect_to '/login'
    end

  end

  def require_guest
    if current_user
      flash[:info_danger] = 'Authorized user cannot be there'
      redirect_to '/'
    end
  end

  def it_is_current_user(user)

    if current_user&&user
      current_user.id == user.id
    end

  end

  def profile_owner
     unless current_user.id == params[:id].to_i
      flash[:info_danger] = 'Access denied'
      redirect_to '/'
    end
  end

end
