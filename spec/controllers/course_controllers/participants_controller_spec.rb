require 'rails_helper'

RSpec.describe CourseControllers::ParticipantsController, type: :controller do
  before(:each) do
    @course = create(:course)
    @target_user = create(:second_user)
  end
  describe 'POST #create' do
    it 'denies access for guests' do
      post :create, params: { course_id: @course.id, id: @target_user.id }
      expect(response).to have_http_status(302)

      set_json_request
      post :create, params: { course_id: @course.id, id: @target_user.id }
      expect(response).to have_http_status(403)
    end

    it 'denies if user is participant already' do
      @course.participants << @target_user
      auth_as(@course.author)

      post :create, params: { course_id: @course.id, id: @target_user.id }
      expect(response).to have_http_status(403)
      expect(response.body).to include('User has already been subscribed')

    end

    it 'denies access for no author' do
      auth_as(@target_user)
      post :create, params: { course_id: @course.id, id: @target_user.id }
      expect(response).to have_http_status(403)

      expected_response = {status: 'Access denied'}.to_json

      expect(response.body).to eq(expected_response)
    end

    it "adds user to course's participants" do
      auth_as(@course.author)
      post :create, params: { course_id: @course.id, id: @target_user.id }
      expect(response).to have_http_status(:success)

      expected_response = {
          user: @target_user.attributes.slice('id', 'username', 'avatar'),
          status: 'Done'
      }.to_json

      expect(response.body).to eq(expected_response)
      expect(@course.participants.include?(@target_user)).to be true
    end
  end

  describe 'DELETE #destroy' do
    it 'denies access for guests' do
      delete :destroy, params: { course_id: @course.id, id: @target_user.id }
      expect(response).to have_http_status(302)

      set_json_request
      delete :destroy, params: { course_id: @course.id, id: @target_user.id }
      expect(response).to have_http_status(403)
    end

    it 'denies access for no author' do
      auth_as(@target_user)
      delete :destroy, params: { course_id: @course.id, id: @target_user.id }
      expect(response).to have_http_status(403)

      expected_response = {status: 'Access denied'}.to_json

      expect(response.body).to eq(expected_response)
    end

    it 'deletes user from courses participants' do
      @course.participants << @target_user
      auth_as(@course.author)
      delete :destroy, params: { course_id: @course.id, id: @target_user.id }
      expect(response).to have_http_status(:success)

      expected_response = {
          user: @target_user.attributes.slice('id', 'username', 'avatar'),
          status: 'Done'
      }.to_json
      expect(response.body).to eq(expected_response)
      expect(@course.participants.include?(@target_user)).to be false
    end
  end
end
