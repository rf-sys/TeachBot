# Handle courses' subscribe/unsubscribe button
class SubscriptionsController < ApplicationController
  before_action :require_user, :set_course

  def create
    if course_in_subscriptions?(@course)
      return fail_response(['Subscription exists already'], 403)
    end
    @course.subscribers << current_user
    head :ok
  end

  def destroy
    @course.subscribers.destroy current_user
    head :ok
  end

  private

  def set_course
    @course = fetch_cache(Course, params[:id])
  end

  def course_in_subscriptions?(course)
    current_user.subscriptions_to_courses.include?(course)
  end
end
