class MainController < ApplicationController
  def index
    @courses = Rails.cache.fetch('courses/recent_courses') do
      Course.where.not(published: false, public: false, poster: nil).last(4)
    end
  end
end
