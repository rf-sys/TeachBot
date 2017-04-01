require 'rails_helper'

RSpec.describe AccountActivationsController, type: :controller do
  include ActiveJob::TestHelper

  describe 'GET #edit' do
    it 'activates account' do
      user = create(:user, activated: false)

      get :edit, params: { email: user.email, id: user.activation_token }

      expect(response).to have_http_status(302)

      user.reload

      expect(user.activated).to be true
      expect(user.activated_at).not_to be nil
    end

    it 'denies access if user not found' do
      user = create(:user, activated: false)

      get :edit, params: { email: 'invalid@gmail.com', id: user.activation_token }

      expect(response).to have_http_status(302)

      user.reload

      expect(user.activated).to be false
      expect(user.activated_at).to be nil
    end

    it 'denies access if user activated' do
      user = create(:user)

      get :edit, params: { email: user.email, id: user.activation_token }

      expect(response).to have_http_status(302)

      user.reload

      expect(user.activated_at).to be nil
    end

    it 'denies access if invalid token' do
      user = create(:user, activated: false)

      get :edit, params: { email: user.email, id: 'invalid' }

      expect(response).to have_http_status(302)

      user.reload

      expect(user.activated).to be false
      expect(user.activated_at).to be nil
    end
  end

  describe 'GET #new' do
    before(:each) do
      @user = create(:user)
    end

    it 'denies access for auth user' do
      auth_as(@user)
      get :new
      expect(response).to have_http_status(302)
    end

    it 'accepts access for guests' do
      get :new
      expect(response).to have_http_status(200)
    end
  end

  describe 'POST #create' do
    before(:each) do
      $redis_connection.del("throttle[activation_email][#{request.remote_ip}]")
      @user = create(:user)
      set_js_request
    end

    it 'check send interval' do
      post :create, params: { user: { email: @user.email } }
      expect(response).to have_http_status(200)

      post :create, params: { user: { email: @user.email } }
      expect(response).to have_http_status(403)
      expect(response.body).to match(/You can send another email/)
    end

    it 'sends email if user not found' do
      expect do
        post :create, params: { user: { email: @user.email } }
      end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end
  end
end
