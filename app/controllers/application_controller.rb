class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user, :it_is_current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    unless current_user
      flash[:danger_notice] = 'You need login to go there'
      redirect_to root_path, status: :forbidden
    end

  end

  def require_guest
    if current_user
      flash[:danger_notice] = 'Authorized user cannot be there'
      redirect_to root_path, status: :forbidden
    end
  end

  def it_is_current_user(user)

    if current_user&&user
      current_user.id == user.id
    end

  end

  def profile_owner
     unless current_user.id == params[:id].to_i
      flash[:danger_notice] = 'Access denied'

      if request.xhr?
        render :json => {:error => ['Access denied']}, status: 403
      else
        redirect_to root_path, status: :forbidden
      end

    end
  end

end
