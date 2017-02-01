require 'rails_helper'

describe 'Conversations', :type => :feature, js: true do
  before :each do
    @initiator = create(:user)
    @recipient = create(:second_user)
    page.set_rack_session(:user_id => @initiator.id)
  end

  it 'creates conversation' do
    puts Chat.count
    visit conversations_path

    expect(page).to have_content('Dialogs')

    fill_in 'Username...', with: @recipient.username
    page.has_css?('table.table')
    expect(page).to have_button('Send message')
    click_button('Send message')
    expect(page).to have_content('New message to ' + @recipient.username)
    message = 'My first dialog with you'
    fill_in 'Type your message', with: message

    find('#modalNewMessage').find_button('Send message').click

    expect(page).to have_content("#{@initiator.username}: #{message} (a few seconds ago)")
  end
end