require 'rails_helper'

describe 'the signin process', type: :feature, js: true do
  before :each do
    @user = create(:user)
  end

  it 'denies access if I am auth' do
    auth_for_capybara(page, @user.id)
    visit login_path
    expect(page).to have_content 'Access denied for authorized user'
  end


  it 'signs me in as valid user' do
    visit login_path
    sleep(1)
    within('#login_form') do
      fill_in 'session_email', with: 'testuser@gmail.com'
      fill_in 'session_password', with: 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'You have been logged in as: ' + @user.username
  end


  it 'signs me in as valid user' do
    visit login_path
    sleep(2)
    within('#login_form') do
      fill_in 'session_email', with: 'testuser@gmail.com'
      fill_in 'session_password', with: 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'You have been logged in as: ' + @user.username
  end

  it 'i cannot signs with invalid data' do
    visit login_path
    sleep(1)
    within('#login_form') do
      fill_in 'session_email', with: 'INVALIDEMAIL@example.com'
      fill_in 'session_password', with: 'password'
    end
    click_button 'Sign in'
    expect(find('#ResponseMessagesBlock')).to have_content 'User with provided credentials not found'
  end
end