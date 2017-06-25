class SearchController < ApplicationController
  before_action :set_request_format

  def index
    result = Searchkick.search params[:text] || '', index_name: [Course, Lesson, User]

    @courses = result.select { |item| item.class.name == 'Course' }

    @lessons = result.select { |item| item.class.name == 'Lesson' }

    @users = result.select { |item| item.class.name == 'User' }
  end

  private

  def set_request_format
    request.format = :json
  end
end
