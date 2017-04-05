require 'rails_helper'

describe 'Notifications', type: :feature, js: true do
  before :each do
    @recipient = create(:user)
    @notification = create(:notification, user: @recipient)
    auth_for_capybara(page, @recipient.id)
    page.driver.resize(1920, 1080)
  end

  it 'returns notifications' do
    visit root_path
    sleep(1)
    find('#notifications_dropdown').find('a').trigger('click')
    sleep(1)
    expect(page).to have_content(@notification.title)
  end
end