require 'rails_helper'

RSpec.describe ApiController, type: :controller do

  describe 'POST #unread_messages_count' do
    it 'returns count of unread messages equals 0 if no unread messages' do
      user = create(:user)
      session[:user_id] = user.id

      post :unread_messages_count
      expect(response.status).to eq(200)
      expect(response.content_type).to eq 'application/json'
      expect(response.body).to match({count: 0}.to_json)
    end


    it 'returns count, equals unread messages' do
      chat = create(:chat)
      user = chat.initiator
      message = create(:message, chat: chat, user: user)

      auth_user_as(user)

      user.unread_messages << [message]
      expect(user.unread_messages.count).to eq (1)
      unread_messages_request(1)

      user.unread_messages << [message]
      expect(user.unread_messages.count).to eq (2)
      unread_messages_request(2)
    end

    it 'denies access for guests' do
      post :unread_messages_count
      expect(response.status).to eq(302)
    end
  end


  private

  def unread_messages_request(count)
    post :unread_messages_count
    expect(response.status).to eq(200)
    expect(response.content_type).to eq 'application/json'

    expect(response.body).to match({count: count}.to_json)
  end
end


