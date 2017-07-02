require 'rails_helper'

RSpec.describe ApiController, type: :controller do
  describe 'POST #user_token' do
    it 'generates jwt token' do
      user = create(:user)
      post :user_token, params: { email: user.email, password: user.password }
      expect(response).to have_http_status(200)
      expect(response.body).to match(/token/)
    end

    it 'returns 404 (not found) error if user not found' do
      user = create(:user)
      post :user_token, params: { email: 'invalid', password: user.password }
      expect(response).to have_http_status(404)
    end

    it 'returns 403 (forbidden) if failed authentication' do
      user = create(:user)
      post :user_token, params: { email: user.email, password: 'invalid' }
      expect(response).to have_http_status(403)
    end
  end
end


