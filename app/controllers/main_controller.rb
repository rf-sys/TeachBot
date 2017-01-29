class MainController < ApplicationController
  def index
    @courses = Course.where.not(published: false, public: false, poster: nil).last(5)
  end
end
