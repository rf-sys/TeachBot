# show rss
class RssController < ApplicationController
  before_action :request_format

  def index
    @lessons = Lesson.belongs_to_public_and_published_courses

    respond_to do |format|
      format.any { render layout: false }
    end
  end

  private

  def request_format
    request.format = :rss
  end
end
