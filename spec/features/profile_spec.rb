require 'rails_helper'
describe 'profile settings process', :type => :feature do
  before :each do
    @user = User.create(:username => 'Oki', :email => 'user@test.com', :password => 'password')
  end

  it 'i can see created user' do
    visit user_path @user
    expect(page).to have_content(@user.username)
    page.has_no_text?('Settings')
  end

end