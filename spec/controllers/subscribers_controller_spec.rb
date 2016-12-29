require 'rails_helper'

RSpec.describe SubscribersController, type: :controller do
  before :each do
    @course = message(:course)
  end

  it 'approves access' do
    # auth user
    session[:user_id] = @course.author_id
    # simulate teacher role
    @course.author.add_role :teacher

    post :message, params: {course_id: @course.id, id: @course.author_id}
    expect(response).to have_http_status(200)
  end

  it 'declines access for no teacher' do
    # auth user
    session[:user_id] = @course.author_id

    post :message, params: {course_id: @course.id, id: @course.author_id}
    expect(response).to have_http_status(302) # indicate redirect status code
  end

  it 'declines access for no auth user' do

    @course.author.add_role :teacher
    post :message, params: {course_id: @course.id, id: @course.author_id}
    expect(response).to have_http_status(302) # indicate redirect status code
  end

  it 'declines access for foreign teacher' do
    user = message(:second_user)

    session[:user_id] = user.id
    user.add_role :teacher

    post :message, params: {course_id: @course.id, id: @course.author_id}
    expect(response).to have_http_status(403) # indicate redirect status code
  end


end
