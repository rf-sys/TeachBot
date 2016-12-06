class CoursesController < ApplicationController
  include CoursesHelper
  before_action :require_user, except: [:index, :show]

  def index
    @public_courses = get_from_cache(Course, 'index', 'all') { Course.where(:public => true) }

    if current_user
      @subscriptions ||= current_user.subscriptions.page(1).per(2)
    end
  end

  def show
    @course = get_from_cache(Course, params[:id]) do
      Course.includes(:author).find(params[:id])
    end

    unless have_access_to_private_course(@course)
      deny_access_message 'You dont have access to browse this course'
    end
  end

  def new
    @course = Course.new
  end

  def create
    course = current_user.courses.create(course_params)
    if course.persisted?
      render :json => {:message => 'Course has been created successfully'}
    else
      render fail_json course.errors.full_messages
    end
  end

  def edit
    @course = Course.find(params[:id])
    check_if_author @course
  end

  def update
    @course = Course.find(params[:id])

    check_if_author(@course)

    if @course.update(course_params)
      render :json => {:message => 'Course has been updated successfully'}
    else
      render fail_json(@course.errors.full_messages)
    end

  end

  private

  def course_params
    params.require(:course).permit(:title, :description, :public)
  end

  def check_if_author(course)
    deny_access_message 'You are not the author of this course' unless is_owner? course
  end

end
