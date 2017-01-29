require_dependency 'services/file_uploader'

class PosterUploader < FileUploader
  def path
   'public/assets/images/courses_posters/'
  end

  def url
   '/assets/images/courses_posters/' + name + '?updated=' + Time.now.to_i.to_s
  end

  def available_formats
   %w(.png .jpg .jpeg .bmp .gif)
  end

  def max_size
   1024
  end
end