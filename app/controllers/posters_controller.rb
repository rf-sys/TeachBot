class PostersController < ApplicationController
  before_action :require_user

  def update
    course = Course.find(params[:course_id])

    unless it_is_current_user(course.author)
      return error_message(['Access denied'], 403)
    end

    unless params.fetch(:course, {}).fetch(:poster, false)
      return error_message(['File not found'], 422)
    end

    file = FileHelper::Uploader::ImageUploader.new(course, 'courses_posters', params[:course][:poster], {max_size: 1024})

    if file.valid?
      file.save
      path = file.path + '?updated=' + Time.now.to_i.to_s
      course.update_attribute('poster', path)
      render :json => {:message => 'Poster has been created successfully', :url => path}, status: :ok
    else
      error_message([file.error], 422)
    end

  end

end
