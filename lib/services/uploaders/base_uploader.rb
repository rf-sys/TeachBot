class BaseUploader
  attr_reader :error

  # set uploaded file
  def initialize(file, file_name)
    @file = file
    @file_name = file_name
  end

  # url to file that is placed in DB
  # @return [String]
  def file_url
    # implements by children
  end

  # set file extension
  # @return [String]
  def extension
    # by default return extension of the uploaded file
    FastImage(@file).type.to_s
  end

  # how we store our file
  def store
   # implements by children
  end

  # accepted file formats
  def available_formats
    []
  end

  # max size of the file
  def max_size
    0
  end

  # max height of the file
  def max_height
    0
  end

  # max width of the file
  def max_width
    0
  end

  #### VALIDATION ####

  def has_valid_file?
    validators
    return true
  rescue => error
    @error = error
    false
  end

  def validators
    # implements by children
  end

  #### default validators ####

  def check_formats
    accepted_formats = available_formats

    unless accepted_formats.include? extension
      raise 'File has no valid type (image required)'
    end
  end

  def check_size
    max = max_size
    if @file.size.to_i > max.kilobytes.to_i
      raise "File is too large (Maximum size: #{max} kb)"
    end
  end

  def check_width
    max = max_width

    if file_width > max_width
      raise "Width is too high. Max width for poster - #{max} px." \
            "Current width: #{file_width} px."
    end
  end

  def check_height
    max = max_height

    if file_height > max_height
      raise "Height is too high. Max height for poster - #{max} px." \
            "Current height: #{file_height} px."
    end
  end

  private

  def file_width
    file_props = FastImage.size(@file)
    return raise 'Impossible to get width of the file' if file_props.blank?
    FastImage.size(@file)[0]
  end

  def file_height
    file_props = FastImage.size(@file)
    return raise 'Impossible to get width of the file' if file_props.blank?
    FastImage.size(@file)[1]
  end
end