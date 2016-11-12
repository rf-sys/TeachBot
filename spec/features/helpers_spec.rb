require 'rails_helper'
describe 'application helpers', :type => :feature, :js => true do

  before :each do
    @user = User.create(username: 'Okalia', email: 'rodion2014@inbox.ru',
                     password_digest: User.digest('password'), activated: true)
  end

  it 'i see notice if user logged in' do
    visit '/login'
    within('#login_form') do
      fill_in 'session_email', :with => 'rodion2014@inbox.ru'
      fill_in 'session_password', :with => 'password'
    end
    click_button 'Sign in'
    puts @user.username
    expect(page).to have_current_path '/'

    expect(page).to have_css('div', text: 'You have been logged in as: Okalia')
  end
end