require 'rails_helper'

RSpec.describe AuthController, type: :controller do
=begin
  describe 'GET #facebook' do
    before :each do
      Rails.application.env_config['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    end

    it 'redirects to Facebook oauth', js: true do
      get :auth_callback
    end
  end

  describe 'GET #github' do
    it 'redirects to GitHub oauth' do
      get :github
      expect(response).to have_http_status(302)
    end
  end

  describe 'GET #auth_callback' do
    it 'authenticates user through Facebook' do
      OmniAuth.config.add_mock(:facebook, {:uid => '107513286430631'})
    end
  end
=end
end
