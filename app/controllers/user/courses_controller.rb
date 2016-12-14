class User::CoursesController < ApplicationController
  def index
=begin
    @user = get_from_cache(User, params[:user_id], 'courses') do
      User.left_outer_joins(:paginate_courses, :paginate_subscriptions).find(params[:user_id])
    end
=end
    @user = User.left_outer_joins(:paginate_courses, :paginate_subscriptions).find(params[:user_id])
  end
end
