require_dependency 'services/uploaders/aws_uploader'

class PosterUploader < AwsUploader

  def extension
    'jpg'
  end

  def file_url
    "uploads/courses_posters/#{@file_name}.#{extension}"
  end

  def available_formats
    %w(png jpg jpeg bmp gif)
  end

  def max_size
    2048
  end

  def max_height
    558
  end

  def max_width
    1536
  end

  def validators
    check_formats
    check_size
    check_height
    check_width
  end
end