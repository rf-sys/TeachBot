class MainController < ApplicationController
  def index
    @lessons = Lesson.last(4)
  end
end
