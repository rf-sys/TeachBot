require_dependency 'services/uploaders/base_uploader'

class AwsUploader < BaseUploader

  # is used outside to set reference to the file on Aws
  # @return [String]
  def aws_url
    $bucket.object(file_url).public_url + '?updated=' + Time.now.to_i.to_s
  end

  def store
    $bucket.object(file_url).upload_file(file_path, {acl: 'public-read'})
  rescue => error
    @error = error
    false
  end

  protected

  # is used to determine file's path that must be uploaded (used by AWS)
  # not supposed to use outside
  # need to be specified in children
  def file_path
    # by default is uses file's path
    @file.path
  end
end