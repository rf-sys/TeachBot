# represents RESTful of the courses
class CoursesController < ApplicationController
  include Services::UseCases::Course::UpdatePosterService
  include CoursesHelper

  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_teacher, except: [:index, :show]
  before_action :set_course, except: [:index, :new, :create]
  before_action :require_course_owner, except: [:index, :show, :new, :create]

  def index
    page = params[:page] || 1
    per = params[:per] || 6

    @courses = Course.public_and_published.order(views: :desc).paginate(page, per)

    respond_to do |format|
      format.json { render json: @courses }
      format.js {}
      format.html {}
    end
  end

  def show
    unless access_to_course?(@course, current_user)
      return fail_response(['You dont have access to browse this course'], 403)
    end

    AddNewCourseViewerJob.perform_later(request.remote_ip, @course.id)
  end

  def new
    @course = Course.new
  end

  def create
    course = current_user.courses.new(course_params)
    if course.save_with_tags(course_params, course_tags(params))
      flash[:super_success_notice] = 'Course has been created successfully'
      redirect_to course
    else
      fail_response(course.errors.full_messages, 422)
    end
  end

  def edit; end

  def update
    if @course.save_with_tags(course_params, course_tags(params))
      redirect_to @course
    else
      fail_response(@course.errors.full_messages, 422)
    end
  end

  def destroy
    @course.destroy
    flash[:success_notice] = 'Course has been deleted'
    redirect_to courses_path
  end

  # update poster of the course
  def update_poster
    unless params.fetch(:course, {}).fetch(:poster, false).present?
      return fail_response(['File not found'], 422)
    end

    repository = Repositories::CourseRepository

    update_poster_service = UpdatePoster.new(repository, self)

    update_poster_service.update(@course, params[:course][:poster])
  end

  # toggle "publish" status of the course
  def toggle_publish
    @course.published = !@course.published
    @course.save
  end

  private

  def set_course
    @course = fetch_cache(Course, params[:id], 'slug') do
      Course.friendly.find(params[:id])
    end
  end

  def course_params
    params.require(:course).permit(:title, :description, :public, :theme)
  end

  def require_course_owner
    return if current_user?(@course.author)
    fail_response(['Access denied'], 403)
  end
end
