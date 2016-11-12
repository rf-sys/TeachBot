require 'rails_helper'
describe 'sign_in process', :type => :feature do
  before :each do
    User.create(:username => 'Oki', :email => 'user@test.com', :password => 'password')
  end

  it 'sign_in show no activated account error' do
    visit '/login'
    within('#login_form') do
      fill_in 'session_email', :with => 'user@test.com'
      fill_in 'session_password', :with => 'password'
    end
    click_button 'Sign in'
    expect(page).to have_content 'Account not activated'
  end
end