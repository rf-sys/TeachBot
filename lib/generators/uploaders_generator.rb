class UploadersGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_initializer_file
    copy_file 'file_uploader_template.rb', Rails.root + "lib/services/uploaders/#{file_name}_uploader.rb"
  end
end