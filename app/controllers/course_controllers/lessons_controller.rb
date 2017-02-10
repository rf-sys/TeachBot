class CourseControllers::LessonsController < ApplicationController
  include CoursesHelper
  before_action :require_user, except: [:show]
  before_action :set_course_and_check_author, except: [:show]

  def show
    @course = Course.friendly.find(params[:course_id])

    unless have_access_to_private_course(@course)
      return invalid_request_message(['You dont have access to browse this course'], 403)
    end

    unless unpublished_and_user_is_author(@course)
      invalid_request_message(['You dont have access to browse this course'], 403)
    end

    @lesson = get_from_cache(Lesson, params[:id]) do
      @course.lessons.friendly.find(params[:id])
    end

  end

  def new
    @lesson = Lesson.new
  end

  def create
    lesson = @course.lessons.new(lesson_params)

    if lesson.save
      NewLessonNotificationJob.perform_later(@course, lesson)
      redirect_to course_lesson_path(@course, lesson)
    else
      error_message(lesson.errors.full_messages, 422)
    end
  end

  private
  def lesson_params
    params.require(:lesson).permit(:title, :description)
  end

  def set_course_and_check_author
    @course = Course.friendly.find(params[:course_id])

    invalid_request_message(['You are not the author of this course'], 403) unless is_owner? @course
  end
end
