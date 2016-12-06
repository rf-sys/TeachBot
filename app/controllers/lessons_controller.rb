class LessonsController < ApplicationController
  before_action :require_user, except: [:show]

=begin
  def index
    @lessons = Lesson.paginate(:page => params[:page], :per_page => 2)
    # here we can organize pagination...
  end
=end

  def show

    @lesson = get_from_cache(Lesson, params[:id]) do
      Lesson.where(:course_id => params[:course_id]).includes(:course).find(params[:id])
    end

    unless have_access_to_private_course(@lesson.course)
      deny_access_message 'You dont have access to browse this course'
    end
  end

  def new
    @course = Course.find(params[:course_id])
    return deny_access_message 'You are not the author of this course' unless is_owner? @course

    @lesson = Lesson.new
  end

  def create
    @course = Course.find(params[:course_id])
    return deny_access_message 'You are not the author of this course' unless is_owner? @course

    lesson = @course.lessons.create(lesson_params)
    if lesson.valid?
      render :json => {:message => 'Lesson has been created successfully'}
    else
      render fail_json(lesson.errors.full_messages)
    end
  end

  private
  def lesson_params
    params.require(:lesson).permit(:title, :description)
  end
end
