class CoursesController < ApplicationController
  include FileHelper::Uploader, Services::UseCases::Course::CreateCourseService

  before_action :require_user, except: [:index, :show, :rss_feed]

  before_action :require_teacher, except: [:index, :show, :rss_feed]

  def index
    @courses = Course.where(:public => true).order(updated_at: :desc).page(params[:page]).per(6)
  end

  def show
    @course = get_from_cache(Course, params[:id]) do
      Course.includes(:author).find(params[:id])
    end

    unless have_access_to_private_course(@course)
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
    @course = Course.find(params[:id])
    check_if_author @course
  end

  def update
    course = Course.find(params[:id])

    check_if_author(course)

    if course.update(course_params)
      redirect_to course
    else
      error_message(course.errors.full_messages, 422)
    end
  end

  def rss_feed
    @courses = Course.where(:public => true)
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end

  private

  def course_params
    params.require(:course).permit(:title, :description, :public, :poster, :theme)
  end

  def check_if_author(course)
    deny_access_message 'You are not the author of this course' unless is_owner? course
  end

  def validate_file(file_manager_entity, request_file = nil)
    if request_file
      return file_manager_entity.valid?
    end
    true
  end

end
