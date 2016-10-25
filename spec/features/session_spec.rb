require 'rails_helper'
describe 'the signin process', :type => :feature do
  before :each do
    User.create(:username => 'Oki', :email => 'user@test.com', :password => 'password')
  end

  it 'sign in with correct credits' do
    visit '/login'
    within('#login_form') do
      fill_in 'session_email', :with => 'user@test.com'
      fill_in 'session_password', :with => 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'TeachBot'
  end


  it 'sign in with wrong credits' do
    visit '/login'
    within('#login_form') do
      fill_in 'session_email', :with => 'user123@test.com'
      fill_in 'session_password', :with => 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'User with this credentials not found'
  end
end