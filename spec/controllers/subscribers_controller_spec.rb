require 'rails_helper'

RSpec.describe SubscribersController, type: :controller do
  before :each do
    @course = create(:course)
    @foreign_user = create(:second_user)
  end

  it 'approves access' do
    # auth user
    session[:user_id] = @course.author_id
    # simulate teacher role
    @course.author.add_role :teacher

    delete :destroy, params: {course_id: @course.id, id: @foreign_user.id}
    expect(response).to have_http_status(200)

  end

  it 'declines access for no teacher' do
    # auth user
    session[:user_id] = @course.author_id

    delete :destroy, params: {course_id: @course.id, id: @foreign_user.id}
    expect(response).to have_http_status(302) # indicate redirect status code
  end

  it 'declines access for no auth user' do

    @course.author.add_role :teacher
    delete :destroy, params: {course_id: @course.id, id: @foreign_user.id}
    expect(response).to have_http_status(302) # indicate redirect status code
  end

  it 'declines access for foreign teacher' do
    @foreign_user.add_role :teacher

    session[:user_id] = @foreign_user.id


    delete :destroy, params: {course_id: @course.id, id: @course.author_id}
    expect(response).to have_http_status(403) # indicate redirect status code
  end


end
