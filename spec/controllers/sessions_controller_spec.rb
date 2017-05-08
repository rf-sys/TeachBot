require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe 'POST #create' do
    before(:each) do
      redis = Redis.new
      redis.del("throttle[login_interval][#{request.remote_ip}]")
    end

    it 'returns success if correct data' do
      user = create(:user)
      post :create, params: {
        session: {
          email:    user.email,
          password: 'password'
        }
      }
      expect(response).to have_http_status(302) # indicate redirect status code
    end

    it 'returns error if user not found' do
      create(:user)
      post :create, params: {
        session: {
          email:    'invalid@example.com',
          password: 'invalid'
        }
      }
      expect(response).to have_http_status(404)
    end

    it 'returns error if user is no activated' do
      user = create(:user, activated: false)

      post :create, params: {
        session: {
          email:    user.email,
          password: 'password'
        }
      }
      expect(response).to have_http_status(404) # indicate redirect status code
      expect(response.body).to match(/Account not activated/)
    end

    it 'returns error if params has no valid password' do
      user = create(:user)
      post :create, params: {
        session: {
          email:    user.email,
          password: 'invalid'
        }
      }

      expect(response).to have_http_status(404) # indicate redirect status code
      expect(response.body).to match(/User with provided credentials not found/)
    end

    it 'denies access if too many attempts' do
      user = create(:user)
      set_json_request

      7.times do
        post :create, params: {
          session: {
            email:    user.email,
            password: 'invalid'
          }
        }
      end

      expect(response).to have_http_status(403)
      expect(response.body).to match(/Too many attempts/)
    end
  end

  describe 'DELETE #destroy' do
    it 'do log out if logged in' do
      user = create(:user)
      session[:user_id] = user.id
      auth_as(user)

      delete :destroy

      expect(session[:user_id].present?).to eq false
    end
  end
end
