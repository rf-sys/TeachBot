require 'rails_helper'

RSpec.describe SubscribersController, type: :controller do
  before :each do
    @course = create(:course)
    @foreign_user = create(:second_user)
  end

  it 'approves access' do
    # auth user
    auth_user_as(@course.author)
    # simulate teacher role
    @course.author.add_role :teacher

    delete :destroy, params: {course_id: @course.id, id: @foreign_user.id}
    expect(response).to have_http_status(200)

  end

  it 'declines access for no teacher' do
    # auth user
    @course.author.remove_role(:teacher)
    auth_user_as(@course.author)

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

    auth_user_as(@foreign_user)


    delete :destroy, params: {course_id: @course.id, id: @course.author_id}
    expect(response).to have_http_status(403) # indicate redirect status code
  end


end
