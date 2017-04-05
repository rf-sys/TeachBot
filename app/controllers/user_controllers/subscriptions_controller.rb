class UserControllers::SubscriptionsController < ApplicationController
  # get user's subscriptions, divided by pagination
  before_action :authenticate_user!, only: [:destroy]
  before_action :set_user

  def index
    subscriptions = @user.subscriptions_to_courses.page(params[:page]).per(4)
    respond_to do |format|
      format.any(:js, :json) do
        render json: {
            subscriptions: subscriptions,
            current_page: params[:page].to_i,
            total_pages: subscriptions.total_pages
        }
      end
      format.html
    end
  end

  # pass course id =)
  def destroy
    return error_message(['Access denied'], 403) unless current_user?(@user)

    course = fetch_cache(Course, params[:id])
    @user.subscriptions_to_courses.destroy(course)
    render json: {status: 'Ok'}
  end

  private

  def set_user
    @user = fetch_cache(User, params[:user_id]) { User.friendly.find(params[:user_id]) }
  end
end
