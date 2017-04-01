require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  require 'services/json_web_token.rb'

  describe 'POST #find_by_username' do
    it 'returns 401 (Unauthorized) if user is guest' do
      post :find_by_username
      expect(response).to have_http_status(401)
    end

    it 'returns 200 (success) if user has been authorized recently' do
      user = create(:user)
      auth_as(user)
      post :find_by_username
      expect(response).to have_http_status(200)
    end

    it 'returns array of user if valid token' do
      user = create(:user)
      token = JsonWebToken.encode(payload(user))
      request.headers['Authorization'] = "Bearer #{token}"

      post :find_by_username, params: { username: user.username }
      expect(response).to have_http_status(200)
    end

    it 'throws "Unauthorized" error if invalid jwt token' do
      user = create(:user)
      token = JsonWebToken.encode(payload(user))

      request.headers['Authorization'] = "Bearer #{token}invalid"

      post :find_by_username, params: { username: user.username }
      expect(response).to have_http_status(401)

      request.headers['Authorization'] = 'Bearer ivalid'

      post :find_by_username, params: { username: user.username }
      expect(response).to have_http_status(401)
    end
  end

  private

  def payload(user)
    {
        iss: Rails.application.config.development_host,
        sub: user.id,
        aud: 'users',
        exp: Time.now.to_i + 1.day
    }
  end
end
