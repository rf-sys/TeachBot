class MainController < ApplicationController
  def index
    @courses = Course.where.not(published: false).where.not(public: false).last(4)
  end
end
