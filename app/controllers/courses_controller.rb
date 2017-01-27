class CoursesController < ApplicationController
  include FileHelper::Uploader, Services::UseCases::Course::UpdatePosterService

  before_action :require_user, except: [:index, :show, :rss_feed]
  before_action :require_teacher, except: [:index, :show, :rss_feed]
  before_action :set_course, except: [:index, :show, :new, :create, :rss_feed]

  def index
    @courses = Course.where_public.where_published.order(updated_at: :desc).page(params[:page]).per(6)
  end

  def show
    @course = get_from_cache(Course, params[:id]) do
      Course.includes(:author).find(params[:id])
    end

    unless have_access_to_private_course(@course)
      deny_access_message 'You dont have access to browse this course'
    end

    unless unpublished_and_user_is_author(@course)
      deny_access_message 'You dont have access to browse this course'
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

  # get user's subscriptions, devided by pagination
  def subscriptions
    user = get_from_cache(User, params[:user_id])
    subscriptions = user.subscriptions.page(params[:page]).per(2)
    render :partial => 'courses/pagination', locals: {subscriptions: subscriptions}
  end

  # return courses, created by specific user and divided by pagination
  def courses
    @user = get_from_cache(User, params[:user_id])
    @courses = @user.courses.page(params[:page]).per(2)
  end

  private

  def set_course
    @course = Course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:title, :description, :public, :poster, :theme)
  end

  def validate_file(file_manager_entity, request_file = nil)
    if request_file
      return file_manager_entity.valid?
    end
    true
  end

end
