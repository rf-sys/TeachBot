class CourseControllers::ParticipantsController < ApplicationController
  before_action :require_user, except: [:index]
  before_action :set_course
  before_action :set_user, :require_owner, except: [:index]

  # GET - returns subscribers of the course
  # @return [Array]
  def index
    render json: { participants: @course.participants.select(:id, :username, :avatar, :slug) }
  end

  def create
    # here id = id (no slug)
    if @user.accessed_courses.where(id: @course.id).any?
      return render json: { status: 'User has already been subscribed' }, status: :forbidden
    end

    @user.accessed_courses << @course
    render json: { user: @user.attributes.slice('id', 'username', 'avatar'), status: 'Done' }
  end

  def destroy
    @user.accessed_courses.delete(@course)

    render json: { user: @user.attributes.slice('id', 'username', 'avatar'), status: 'Done' }
  end

  private

  def set_course
    @course = fetch_cache(Course, params[:course_id])
  end

  def set_user
    @user = fetch_cache(User, params[:id])
  end

  def require_owner
    unless owner?(@course)
      render :json => {status: 'Access denied'}, status: :forbidden
    end
  end
end
