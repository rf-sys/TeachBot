require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  include ActiveJob::TestHelper

  describe 'GET #show' do
    it 'returns user' do
      user = create(:user)

      get :show, params: {id: user.slug}

      expect(response).to have_http_status(200)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    it 'adds confirmation email into job queue' do
      expect {
        post :create, params: {user: FactoryGirl.attributes_for(:user)}
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'creates user' do
      expect {
        post :create, params: {user: FactoryGirl.attributes_for(:user)}
      }.to change(User, :count).by(1)
    end

    it 'returns validation errors' do
      post :create, params: {
          user: {
              username: '',
              email: '',
              password: '',
              password_confirmation: ''
          }
      }
      expect(response).to have_http_status(422)

      expect(response.body).to match(/Username can't be blank/)
      expect(response.body).to match(/Email is not an email/)
      expect(response.body).to match(/Password is too short/)
      expect(response.body).to match(/Password confirmation doesn't match Password/)
    end

    it 'does not save invalid user' do
      expect {
        post :create, params: {
            user: {
                username: '',
                email: '',
                password: '',
                password_confirmation: ''
            }
        }
        expect(response).to have_http_status(422)
      }.to change(User, :count).by(0)
    end
  end

  describe 'PUT/PATCH #update' do
    it 'updates user' do
      user = create(:user)
      auth_as(user)
      patch :update, params: {
          id: user.friendly_id,
          user: {
              username: 'updated_username',
              email: user.email,
              profile_attributes: {
                  website: '',
                  facebook: '',
                  twitter: '',
                  about: 'Test user about',
                  location: '',
                  id: user.id
              }
          }
      }
      user.reload

      expect(response).to have_http_status(302)
      expect(user.username).to eq('updated_username')
      expect(user.profile.about).to eq('Test user about')
    end
  end
end