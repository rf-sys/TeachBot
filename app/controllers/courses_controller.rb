# represents RESTful of the courses
class CoursesController < ApplicationController
  include Services::UseCases::Course::UpdatePosterService
  include CoursesHelper

  before_action :authenticate_user!, except: [:index, :show]
  before_action :require_teacher, except: [:index, :show]
  before_action :set_course, except: [:index, :new, :create]
  before_action :require_course_owner, except: [:index, :show, :new, :create]

  # show
  after_action :mark_visit, only: [:show]
  after_action :add_view, only: [:show]
  after_action :increase_tags_popularity, only: [:show]
  after_action :increase_tags_recommendation, only: [:show]


  def index
    page = params[:page] || 1
    per = params[:per] || 6

    @courses = Course.public_and_published.includes(:tags)
                     .order(views: :desc).paginate(page, per)

    @popular_tags = load_popular_tags

    @recommendations = load_recommendations if current_user.present?

    respond_to do |format|
      format.json { render json: @courses }
      format.js {}
      format.html {}
    end
  end

  def show
    unless access_to_course?(@course, current_user)
      fail_response(['You dont have access to browse this course'], 403)
    end
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

  def edit;
  end

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

  def mark_visit
    visit = Services::Access::RecentVisit.new(request.remote_ip, @course)
    visit.mark_recent_visit_until(Time.zone.tomorrow)
  end

  def add_view
    return if visited_recently?(request.remote_ip, @course)
    AddNewCourseViewerJob.perform_later(@course.id)
  end

  def increase_tags_popularity
    return if visited_recently?(request.remote_ip, @course)
    IncreaseTagsPopularityJob.perform_later(@course.tags.pluck(:name))
  end

  def increase_tags_recommendation
    return unless current_user.present?
    tags = @course.tags.pluck(:name)
    IncreaseTagsRecommendationJob.perform_later(tags, current_user.id)
  end


  def load_popular_tags
    RedisSingleton.instance.zrevrange('popular_tags', 0, 6)
  end

  def load_recommendations
    key = RedisGlobals.user_recommendations(current_user.id)
    courses_ids = RedisSingleton.instance.zrange(key, 0, 6)
    Course.find(courses_ids).first(3)
  end
end
