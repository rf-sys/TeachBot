# represents RESTful of the courses
class CoursesController < ApplicationController
  include Services::UseCases::Course::UpdatePosterService
  include CoursesHelper
  require_dependency 'services/query_master.rb'

  before_action :require_user, except: [:index, :show]
  before_action :require_teacher, except: [:index, :show]
  before_action :set_course, except: [:index, :new, :create]
  before_action :require_course_owner, except: [:index, :show, :new, :create]
  before_action :prepare_params, only: [:index]

  def index
    page = params[:page] || 1
    per = params[:per] || 6
    master = QueryMaster.new(Course)

    @courses = master.query(request).public_and_published.paginate(page, per)

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
      fail_response(course.errors.full_messages, 422)
    end
  end

  def edit;
  end

  def update
    if @course.update(course_params)
      redirect_to @course, status: :ok
    else
      fail_response(@course.errors.full_messages, 422)
    end
  end

  def destroy
    @course.destroy
    flash[:success_notice] = 'Course has been deleted'
    redirect_to courses_path, status: :ok
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

  def prepare_params
    request.params[:find_by] = 'title' unless params[:find_by].present?
    request.params[:order] = 'title' unless params[:order].present?
    request.params[:order_type] = 'asc' unless params[:order_type].present?
    params[:per] = 6 if params[:per].to_i < 1
  end

  def require_course_owner
    return if it_is_current_user(@course.author)
    fail_response(['Access denied'], 403)
  end
end
