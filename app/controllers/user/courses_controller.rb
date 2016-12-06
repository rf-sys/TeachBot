class User::CoursesController < ApplicationController
  def index
    @user = get_from_cache(User, params[:user_id], 'courses') do
      User.includes(:courses).find(params[:user_id])
    end
  end
end
