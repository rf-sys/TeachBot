require_dependency 'services/uploaders/local_uploader'

class LocalAvatarUploader < LocalUploader
  def extension
    'jpg'
  end

  def file_path
    'public/assets/images/avatars/'
  end

  def file_url
    "/assets/images/avatars/#{@file_name}.#{extension}?updated=#{Time.now.to_i.to_s}"
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