class CoursesController < ApplicationController
  include CoursesHelper
  include FileHelper::Uploader
  before_action :require_user, except: [:index, :show]

  before_action :require_teacher, except: [:index, :show]

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

    @views = Redis.new.get("courses/#{@course.id}/visitors") || 0

    AddNewCourseViewerJob.perform_later(request.remote_ip, @course.id)
  end

  def new
    @course = Course.new
  end

  def create
    course = current_user.courses.create(course_params)

    unless course.persisted?
      return error_message(course.errors.full_messages, 422)
    end

    unless params[:course][:poster].nil?
      file = ImageUploader.new(course, 'courses_posters', params[:course][:poster], {max_size: 1024})
      if file.valid?
        course.update_column('poster', file.path + '?updated=' + Time.now.to_i.to_s)
        file.save
      else
        return error_message([file.error], 422)
      end
    end
    render :json => {:message => 'Course has been created successfully'}
  end

  def edit
    @course = Course.find(params[:id])
    check_if_author @course
  end

  def update
    @course = Course.find(params[:id])

    check_if_author(@course)

    request_file = params[:course][:poster]

    file = ImageUploader.new(@course, 'courses_posters', request_file, {max_size: 1024})

    unless validate_file(file, request_file)
      return error_message([file.error], 422)
    end

    params[:course][:poster] = file.path + '?updated=' + Time.now.to_i.to_s

    if @course.update(course_params) && file.save
      render :json => {:message => 'Course has been updated successfully'}
    else
      error_message(@course.errors.full_messages, 422)
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
