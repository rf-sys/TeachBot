module CourseControllers
  # 123
  class LessonsController < ApplicationController
    include CoursesHelper
    before_action :require_user, except: [:show]
    before_action :set_course
    before_action :require_course_author, except: [:show]
    before_action :set_lesson, only: [:edit, :update, :destroy]

    def show
      unless access_to_course?(@course, current_user)
        return fail_response([access_denied_message], 403)
      end

      @lesson = fetch_cache(Lesson, params[:id], 'slug') do
        Lesson.friendly.find(params[:id])
      end
    end

    def new
      @lesson = Lesson.new
    end

    def edit; end

    def create
      lesson = @course.lessons.new(lesson_params)
      if lesson.save
        NewLessonNotificationJob.perform_later(@course.id, lesson.id)
        redirect_to course_lesson_path(@course, lesson)
      else
        error_message(lesson.errors.full_messages, 422)
      end
    end

    def update
      if @lesson.update(lesson_params)
        redirect_to course_lesson_path(@course, @lesson)
      else
        fail_response(@lesson.errors.full_messages, 422)
      end
    end

    def destroy
      @lesson.destroy

      respond_to do |format|
        format.html { redirect_to @course }
        format.js {}
      end
    end

    private

    def lesson_params
      params.require(:lesson).permit(:title, :description, :content)
    end

    def set_lesson
      @lesson = fetch_cache(Lesson, params[:id], 'slug') do
        Lesson.friendly.find(params[:id])
      end
    end

    def set_course
      @course = fetch_cache(Course, params[:course_id], 'slug') do
        Course.friendly.find(params[:course_id])
      end
    end

    def require_course_author
      return if owner? @course
      fail_response([no_author_message], 403)
    end

    def access_denied_message
      'You dont have access to browse this course'
    end

    def no_author_message
      'You are not the author of this course'
    end
  end
end
