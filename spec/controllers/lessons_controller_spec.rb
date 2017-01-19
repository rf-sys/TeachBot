require 'rails_helper'

RSpec.describe LessonsController, :type => :controller do
  describe 'GET #show' do
    it 'denies access when current_user don\'t have access to private course (html request)' do
      course = create(:course, public: false)
      lesson = create(:lesson, course: course)

      foreign_user = create(:second_user)
      session[:user_id] = foreign_user.id

      get :show, params: {course_id: lesson.course.id, id: lesson.id}
      expect(response.status).to eq(302)

      request.headers['ACCEPT'] = 'application/json'
      get :show, params: {course_id: lesson.course.id, id: lesson.id}
      expect(response.status).to eq(403)
    end

    it 'returns success if public course' do
      course = create(:course)
      lesson = create(:lesson, course: course)

      get :show, params: {course_id: lesson.course.id, id: lesson.id}
      expect(response.status).to eq(200)
    end
  end

  describe 'POST #create' do
    before(:each) do
      @course = create(:course)
      @params = {
          course_id: @course.id,
          lesson: {
              title: 'Test Lesson Title',
              description: 'Test Lesson Description'
          }
      }
    end

    it 'do redirect if current user is not an author of the course' do
      foreign_user = create(:second_user)
      session[:user_id] = foreign_user.id

      post :create, params: @params
      expect(response).to have_http_status(302)
    end

    it 'returns validation errors' do
      session[:user_id] = @course.author.id
      post :create, params: {course_id: @course.id, lesson: {title: '', description: ''}}

      expect(response.body).to match(/Title can't be blank/)
      expect(response.body).to match(/Description can't be blank/)
    end

    it 'creates lesson' do
      session[:user_id] = @course.author.id

      expect {
        post :create, params: @params
      }.to change(Lesson, :count).by(1)

      expect(response).to have_http_status(302)
    end
  end


end
