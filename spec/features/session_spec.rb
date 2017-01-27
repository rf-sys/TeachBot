require 'rails_helper'

describe 'the signin process', :type => :feature do

  it 'signs me in as valid user', js: true do
    user = create(:user)
    visit login_path
    within('#login_form') do
      fill_in 'session_email', with: 'testuser@gmail.com'
      fill_in 'session_password', with: 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'You have been logged in as: ' + user.username
  end

  it 'i cannot signs with invalid data', js: true do
    create(:user)
    visit login_path
    within('#login_form') do
      fill_in 'session_email', with: 'INVALIDEMAIL@example.com'
      fill_in 'session_password', with: 'password'
    end
    click_button 'Sign in'
    expect(find('#ResponseMessagesBlock')).to have_content 'User with provided credentials not found'
  end
end