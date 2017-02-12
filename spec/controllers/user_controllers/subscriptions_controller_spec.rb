require 'rails_helper'

RSpec.describe UserControllers::SubscriptionsController, type: :controller do
  describe 'GET #index' do
    it 'returns subscriptions' do
      user = create(:user)
      course = create(:course, author: user)
      user.subscriptions_to_courses << course

      get :index, params: {user_id: user.friendly_id}
      expect(response).to have_http_status(:success)

      set_json_request

      get :index, params: {user_id: user.friendly_id}
      expect(response.body).to include user.subscriptions_to_courses.to_json
    end
  end

  describe 'DELETE #destroy' do
    it 'denies access for guests' do
      user = create(:user)
      course = create(:course, author: user)

      delete :destroy, params: {id: course.id, user_id: user.id}
      expect(response).to have_http_status(302)
    end

    it 'denies access for foreign user' do
      user = create(:user)
      course = create(:course, author: user)
      second_user = create(:second_user)
      auth_as(second_user)

      delete :destroy, params: {id: course.id, user_id: user.id}
      expect(response).to have_http_status(403)
    end

    it 'accepts access for owner' do
      user = create(:user)
      course = create(:course, author: user)
      auth_as(user)

      delete :destroy, params: {id: course.id, user_id: user.friendly_id}
      expect(response).to have_http_status(200)
    end
  end

end
