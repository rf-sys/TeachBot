class MainController < ApplicationController

  def index
    @lessons = [
        {title: 'first', body: 'first_body'}, {title: 'second', body: 'second_body'},
        {title: 'third', body: 'third_body'}, {title: 'fourth', body: 'fourth_body'}
    ]
  end
end
