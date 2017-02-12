class UserControllers::CoursesController < ApplicationController
  before_action :require_user, only: [:destroy]

  def index
    @user = get_from_cache(User, params[:user_id]) { User.friendly.find(params[:user_id]) }
    respond_to do |format|
      format.html {}
      format.any(:js, :json) do
        @courses = @user.courses.order('created_at ASC').page(params[:page]).per(4)
      end
    end
  end

  def destroy
    user = get_from_cache(User, params[:user_id])
    course = get_from_cache(Course, params[:id])

    unless is_owner?(course)
      return error_message(['Forbidden'], 403)
    end

    user.courses.destroy(course)
    render json: {status: 'Ok'}
  end
end
