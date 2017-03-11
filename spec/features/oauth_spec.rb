require 'rails_helper'

describe 'OAuth process', :type => :feature do
  describe 'Facebook login', js: true do
    it 'can log in user with facebook account' do
      user = omniauth_facebook_mock_user
      visit login_path
      click_link 'Login with Facebook'
      expect(page).to have_content user[:info][:name]
      expect(page).to have_content "You have been logged in as: #{user[:info][:name]}"
    end

    it 'can handle invalid request' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_credentials
      visit login_path
      click_link 'Login with Facebook'
      expect(page).to have_content 'Authentication failed'
    end
  end

  describe 'GitHub login', js: true do
    it 'can log in user with facebook account' do
      user = omniauth_github_mock_user
      visit login_path
      click_link 'Login with GitHub'
      expect(page).to have_content user[:info][:name]
      expect(page).to have_content "You have been logged in as: #{user[:info][:name]}"
    end

    it 'can handle invalid request' do
      OmniAuth.config.mock_auth[:github] = :invalid_credentials
      visit login_path
      click_link 'Login with GitHub'
      expect(page).to have_content 'Authentication failed'
    end
  end
 end