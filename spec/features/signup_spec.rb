require 'rails_helper'

describe 'the signin process', type: :feature, js: true do
  it 'should sign up me if valid data' do
    visit signup_path
    within('#new_user') do
      fill_in 'user_username', with: 'Okalia'
      fill_in 'user_email', with: 'okalia@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
    end
    click_button 'Create User'
    expect(page).to have_content 'Please check okalia@example.com to activate your account'
  end
end