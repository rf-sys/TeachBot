class LessonsController < ApplicationController
  def index
    @lessons = Lesson.paginate(:page => params[:page], :per_page => 2)
    # here we can organize pagination...
  end

  def show
    @lesson = Lesson.find(params[:id])
  end
end
