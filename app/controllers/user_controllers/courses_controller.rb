class UserControllers::CoursesController < ApplicationController
  def index
    @user = get_from_cache(User, params[:user_id], 'courses') do
      User.left_outer_joins(:paginate_courses, :paginate_subscriptions).find(params[:user_id])
    end
  end

  # get user's subscriptions, devided by pagination
  def subscriptions
    @user = get_from_cache(User, params[:user_id])
    subscriptions = @user.subscriptions.page(params[:page]).per(2)
    render :partial => 'courses/pagination', locals: { subscriptions: subscriptions}
  end

  # return courses, created by specific user and divided by pagination
  def courses
    @user = get_from_cache(User, params[:user_id])
    @courses = @user.courses.order('created_at ASC').courses_with_paginate(params[:page])
  end
end
