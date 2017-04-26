class AttachmentsController < ApplicationController
  before_action :authenticate_user!

  def attachment
    url = CGI.escapeHTML(params.require(:url))
    render json: Services::AttachmentGenerator::Generator.new(url).attachment
  rescue StandardError
    fail_response(['Resource is invalid or unavailable'], 403)
  end
end
