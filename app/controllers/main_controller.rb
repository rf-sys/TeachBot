class MainController < ApplicationController
  def index
    @courses = Rails.cache.fetch('courses/recent_courses', expires_in: 12.hours) do
      Course.where.not(published: false, public: false, poster: nil).last(5)
    end
  end
end
