require_dependency 'services/file_uploader'

class AvatarUploader < FileUploader
  def path
    'public/assets/images/avatars/'
  end

  def url
    '/assets/images/avatars/' + name + '?updated=' + Time.now.to_i.to_s
  end

  def available_formats
    %w(.png .jpg .jpeg .bmp .gif)
  end

  def max_size
    500
  end
end