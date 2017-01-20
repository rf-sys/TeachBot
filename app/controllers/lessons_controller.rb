class LessonsController < ApplicationController
  before_action :require_user, except: [:show]
  before_action :set_course_and_check_author, except: [:show]

  def show

    @lesson = Lesson.where(:course_id => params[:course_id]).includes(:course).find(params[:id])

    unless have_access_to_private_course(@lesson.course)
      return deny_access_message 'You dont have access to browse this course'
    end

    unless unpublished_and_user_is_author(@lesson.course)
      deny_access_message 'You dont have access to browse this course'
    end

  end

  def new
    @lesson = Lesson.new
  end

  def create
    lesson = @course.lessons.new(lesson_params)

    if lesson.save
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
    @course = Course.find(params[:course_id])

    deny_access_message 'You are not the author of this course' unless is_owner? @course
  end
end
