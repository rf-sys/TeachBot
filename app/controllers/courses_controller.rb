class CoursesController < ApplicationController
  include Services::UseCases::Course::UpdatePosterService
  include CoursesHelper

  before_action :require_user, except: [:index, :show, :rss_feed]
  before_action :require_teacher, except: [:index, :show, :rss_feed, :subscribe, :unsubscribe]
  before_action :set_course, except: [:index, :show, :new, :create, :rss_feed]

  def index
    @courses = Course.where_public.where_published.order(updated_at: :desc).page(params[:page]).per(6)
  end

  def show
    @course = get_from_cache(Course, params[:id]) do
      Course.includes(:author).friendly.find(params[:id])
    end

    unless have_access_to_private_course(@course)
      return invalid_request_message(['You dont have access to browse this course'], 403)
    end

    unless unpublished_and_user_is_author(@course)
      return invalid_request_message(['Course has not been published yet'], 403)
    end

    @views = $redis_connection.get("courses/#{@course.id}/visitors") || 0

    AddNewCourseViewerJob.perform_later(request.remote_ip, @course.id)
  end

  def new
    @course = Course.new
  end

  def create
    course = current_user.courses.new(course_params)
    if course.save
      flash[:super_success_notice] = 'Course has been created successfully'
      redirect_to course
    else
      error_message(course.errors.full_messages, 422)
    end
  end

  def edit
    unless it_is_current_user(@course.author)
      error_message(['Access denied'], 403)
    end
  end

  def update
    unless it_is_current_user(@course.author)
      return error_message(['Access denied'], 403)
    end

    if @course.update(course_params)
      redirect_to @course
    else
      error_message(@course.errors.full_messages, 422)
    end
  end

  def destroy
    unless it_is_current_user(@course.author)
      return error_message(['Access denied'], 403)
    end

    @course.destroy
    flash[:success_notice] = 'Course has been deleted'
    redirect_to courses_path
  end

  def rss_feed
    @courses = Course.where(:public => true)
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  # update poster of the course
  def update_poster
    unless it_is_current_user(@course.author)
      return error_message(['Access denied'], 403)
    end

    unless params.fetch(:course, {}).fetch(:poster, false)
      return error_message(['File not found'], 422)
    end

    update_poster_service = UpdatePoster.new(Repositories::CourseRepository, self)

    update_poster_service.update(@course, params[:course][:poster])
  end

  # toggle "publish" status of the course
  def toggle_publish
    unless it_is_current_user(@course.author)
      return error_message(['Access denied'], 403)
    end
    @course.published = !@course.published
    @course.save
  end

  # subscribe current user to course
  def subscribe
    if course_in_subscriptions?(@course)
      return error_message(['Subscription exists already'], 403)
    end
    current_user.subscriptions_to_courses << @course
    head :ok
  end

  # unsubscribe current user from course
  def unsubscribe
    current_user.subscriptions_to_courses.delete(@course)
    head :ok
  end

  private

  def set_course
    @course = Course.friendly.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :description, :public, :poster, :theme)
  end

  def course_in_subscriptions?(course)
    current_user.subscriptions_to_courses.include?(course)
  end
end
