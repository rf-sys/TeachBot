require 'rails_helper'

RSpec.describe CourseControllers::LessonsController, type: :controller do
  describe 'GET #show' do
    it 'denies access when current_user don\'t have access to private course (html request)' do
      course = create(:course, public: false)
      lesson = create(:lesson, course: course)

      foreign_user = create(:second_user)
      auth_as(foreign_user)

      get :show, params: {course_id: lesson.course.id, id: lesson.id}
      expect(response.status).to eq(302)

      request.headers['ACCEPT'] = 'application/json'
      get :show, params: {course_id: lesson.course.id, id: lesson.id}
      expect(response.status).to eq(403)
    end

    it 'denies access if auth user isn\'t author and the course is unpublished' do
      course = create(:unpublished_course)
      lesson = create(:lesson, course: course)

      foreign_user = create(:second_user)
      auth_as(foreign_user)

      get :show, params: {course_id: lesson.course.id, id: lesson.id}
      expect(response.status).to eq(302)

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
              description: 'Test Lesson Description',
              content: 'Test Lesson Content'
          }
      }
    end

    it 'do redirect if current user is not an author of the course' do
      foreign_user = create(:second_user)
      auth_as(foreign_user)

      post :create, params: @params
      expect(response).to have_http_status(302)
    end

    it 'returns validation errors' do
      auth_as(@course.author)
      post :create, params: {course_id: @course.id, lesson: {title: '', description: ''}}

      expect(response.body).to match(/Title can't be blank/)
      expect(response.body).to match(/Description can't be blank/)
    end

    it 'creates lesson' do
      auth_as(@course.author)

      expect {
        post :create, params: @params
      }.to change(Lesson, :count).by(1)

      expect(response).to have_http_status(302)
    end
  end

  describe 'PUT/PATCH #update' do
    before :each do
      @course = create(:course, public: true)

      @lesson = create(:lesson, course: @course)

      @update_params = {
          course_id: @course.id,
          id: @lesson.friendly_id,

          lesson: {
              title: 'UPDATED LESSON TITLE'
          }
      }
    end

    it 'updates lesson' do
      auth_as(@course.author)

      put :update, params: @update_params

      expect(response).to have_http_status(302) # expect redirect to the show action after success

      @lesson.reload # update database record to see changes

      expect(@lesson.title).to eq(@update_params[:lesson][:title])
    end

    it 'denies access for no author of the course (lesson belongs to course)' do
      foreign_user = create(:second_user)
      auth_as(foreign_user)

      put :update, params: @update_params

      expect(response).to have_http_status(302) # expect redirect to the home page

      set_json_request

      put :update, params: @update_params

      expect(response).to have_http_status(403) # expect 403 error if json request

      @lesson.reload # update database record to see changes

      expect(@lesson.title).not_to eq(@update_params[:lesson][:title])
    end

    it 'raises validation errors' do
      auth_as(@course.author)

      @update_params[:lesson][:title] = ''


      # html request format
      put :update, params: @update_params

      expect(response).to have_http_status(302) # expect redirect to the home page is no json request

      @lesson.reload # update database record to see changes

      expect(@lesson.title).not_to eq(@update_params[:lesson][:title])


      set_json_request

      # json request format
      put :update, params: @update_params

      expect(response).to have_http_status(422) # expect redirect to the home page is no json request

      @lesson.reload # update database record to see changes

      expect(@lesson.title).not_to eq(@update_params[:lesson][:title])

    end
  end

  describe 'DELETE #destroy' do
    before :each do
      @course = create(:course)
      @lesson = create(:lesson, course: @course)
      expect(Lesson.count).to eq(1)
    end

    it 'denies access for guests' do
      delete :destroy, params: {course_id: @course.id, id: @lesson.id}

      expect(response).to have_http_status(302)

      set_json_request

      delete :destroy, params: {course_id: @course.id, id: @lesson.id}
      expect(response).to have_http_status(403)

      expect(Lesson.count).to eq(1)
    end

    it 'denies access for no author' do
      auth_as(create(:second_user))
      delete :destroy, params: {course_id: @course.id, id: @lesson.id}

      expect(response).to have_http_status(302)

      set_json_request
      delete :destroy, params: {course_id: @course.id, id: @lesson.id}

      expect(response).to have_http_status(403)
      expect(Lesson.count).to eq(1)
    end

    it 'accepts access for author' do
      auth_as(@course.author)

      set_js_request

      delete :destroy, params: {course_id: @course.id, id: @lesson.id}

      expect(response).to have_http_status(200)

      expect(Lesson.count).to eq(0)
    end
  end
end
