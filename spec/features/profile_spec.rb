require 'rails_helper'

describe 'profile settings process', :type => :feature do

  before :each do
    @user = User.create(username: 'Kari', email: 'rodion2014@inbx.ru', password_digest: User.digest('pass'))
  end

  it "i see user's profile" do
    visit user_path(@user)

    expect(page).to have_current_path(user_path(@user))
    expect(page).to have_content @user.username
    expect(page).to have_content @user.email
    expect(page).to have_css('img#user_avatar')

  end

  it 'i cannot see foreign Settings' do
    visit user_path @user
    expect(page).to have_content(@user.username)
    page.has_no_text?('Settings')
  end

  it 'i see my Settings button' do
    assert !@user.activated?
    visit edit_account_activation_path(@user.activation_token, email: @user.email, host: 'localhost:3000')
    @user.reload
    assert @user.activated?


  end
end