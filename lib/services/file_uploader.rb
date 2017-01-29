class FileUploader

  attr_reader :error

  # @param [File] file
  # @param [String] file_name
  def initialize(file, file_name)
    @file = file
    @file_name = file_name
    @error = []
  end

  def store
    File.open(Rails.root.join(path, name), 'wb') do |file|
      file.write(@file.read)
    end
  end

  #### DYNAMIC ####

  # physical path to file
  def path
  end

  # url to file that takes from DB
  def url
  end

  # name and extension of the file
  def name
    "#{@file_name}#{File.extname(@file.original_filename)}" # default
  end

  # accepted file formats
  def available_formats
    []
  end

  # max size of the file
  def max_size
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
    check_formats
    check_size
    yield if block_given?
  end

  #### VALIDATORS ####

  def check_formats
    accepted_formats = available_formats
    unless accepted_formats.include? File.extname(@file.original_filename).downcase
      raise 'File has no valid type (image required)'
    end
  end

  def check_size
    size = max_size
    if @file.size >= size.kilobytes
      raise "File is too large (Maximum size: #{size} kb)"
    end
  end
end