require_dependency 'services/uploaders/aws_uploader'

class AvatarUploader < AwsUploader

  def extension
    'jpg'
  end

  def file_url
    "uploads/avatars/#{@file_name}.#{extension}"
  end

  def available_formats
    %w(png jpg jpeg bmp gif)
  end

  def max_size
    500
  end

  def validators
    check_formats
    check_size
  end
end