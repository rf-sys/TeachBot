class SubscribersController < ApplicationController
  before_action :require_user, :require_teacher

  def create
    course = Course.find(params[:course_id])

    unless is_owner?(course)
      return render :json => {status: 'Access denied'}, status: :forbidden
    end

    user = get_from_cache(User, params[:id])

    if user.subscriptions.where(id: course.id).any?
      return render :json => {status: 'User has already been subscribed'}, status: :forbidden
    end

    if user.subscriptions << course
      render :json => {user: user.attributes.slice('id', 'username', 'avatar'), status: 'Done'}
    else
      render :json => {status: user.errors}, status: :unprocessable_entity
    end
  end

  def destroy

    if @current_user.id == params[:id].to_i
      return render :json => {status: 'Author cannot unsubscribe yourself'}, status: :forbidden
    end

    course = Course.find(params[:course_id])

    unless is_owner?(course)
      return render :json => {status: 'Access denied'}, status: :forbidden
    end

    user = get_from_cache(User, params[:id])

    user.subscriptions.delete(course)

    render :json => {user: user.attributes.slice('id', 'username', 'avatar'), status: 'Done'}

  end

end
