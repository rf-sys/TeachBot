require 'rails_helper'

describe 'Notifications', type: :feature, js: true do
  before :each do
    @recipient = create(:user)
    auth_for_capybara(page, @recipient.id)
    page.driver.resize(1920, 1080)
  end

  it 'returns notifications' do
    notification = create(:notification, user: @recipient)
    visit root_path
    sleep(2)
    bell.trigger('click')
    sleep(2)
    expect(dropdown).to have_content(notification.title)
  end

  it 'loads more notifications' do
    # consider we load 3 notifications per page
    # 3 - one page, 2 - another page

    # index starts with 0
    5.times do |index|
      create(
        :notification,
        user:  @recipient,
        title: "notification #{index} title",
        text:  "notification #{index} text",
        link:  "notification #{index} link"
      )
    end

    visit root_path
    sleep(2)
    bell.trigger('click')
    sleep(2)
    expect(dropdown).to have_selector('.list-group-item', count: 3)
    load_button.trigger('click')
    sleep(2)
    expect(dropdown).to have_selector('.list-group-item', count: 5)
  end

  it 'shows unread notifications count' do
    create(:notification, user: @recipient)
    visit root_path
    sleep(2)
    expect(counter).to have_content '1'
  end

  it 'clears unread notifications count when open notifications' do
    create(:notification, user: @recipient)
    visit root_path
    sleep(2)
    expect(counter).to have_content '1'
    bell.trigger('click')
    sleep(2)
    expect(page).not_to have_selector '#notifications_app_counter'
  end



  private

  def bell
    find('#notifications_app_bell')
  end

  def dropdown
    find('#notifications_app_dropDown')
  end

  def load_button
    find('#notifications_app_load_button')
  end

  def counter
    find('#notifications_app_counter')
  end
end
