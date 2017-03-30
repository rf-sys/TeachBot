class SearchController < ApplicationController
  before_action :set_request_format

  def index
    result = Searchkick.search params[:text] || '', index_name: [Course, Lesson, User]

    @courses = result.reject { |item| item.class.name != 'Course' }

    @lessons = result.reject { |item| item.class.name != 'Lesson' }

    @users = result.reject { |item| item.class.name != 'User' }
  end

  private

  def set_request_format
    request.format = :json
  end
end
