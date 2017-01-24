require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do
  before :each do
    create(:user)
  end

  describe 'POST #create' do
    it 'returns success if correct data' do
      post :create, params: {
          session: {
              email: 'testuser@gmail.com',
              password: 'password'
          }
      }
      expect(response).to have_http_status(302) # indicate redirect status code
    end

    it 'returns error if user not found' do
      post :create, params: {
          session: {
              email: 'invalid@example.com',
              password: 'invalid'
          }
      }
      expect(response).to have_http_status(404)
    end
  end
end