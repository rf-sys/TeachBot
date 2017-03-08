require_dependency 'services/uploaders/base_uploader'

class LocalUploader < BaseUploader

  # define the dir where need to store file
  # @return [String]
  def file_path
    # implements by children
  end

  def store
    File.open(Rails.root.join(file_path, "#{@file_name}.#{extension}"), 'wb') do |file|
      file.write(@file.read)
    end
  end
end