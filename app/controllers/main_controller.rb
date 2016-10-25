class MainController < ApplicationController


  def index
    @lessons = [
        {title: 'first', body: 'first_body'}, {title: 'second', body: 'second_body'},
        {title: 'first', body: 'third_body'}, {title: 'second', body: 'fourth_body'}
    ]
  end
end
