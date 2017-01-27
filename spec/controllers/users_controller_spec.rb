require 'rails_helper'

RSpec.describe UsersController, :type => :controller do
  include ActiveJob::TestHelper

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
end