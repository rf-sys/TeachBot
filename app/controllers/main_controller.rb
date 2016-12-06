class MainController < ApplicationController
  def index
    @courses = Course.last(4)
  end
end
