require 'rails_helper'

RSpec.describe ChatControllers::MessagesController, type: :controller do
  describe 'POST #create' do
    before :each do
      @chat = create(:chat)
    end
    it 'denies access for guests' do
      post :create, params: {chat_id: @chat.id}
      expect(response).to have_http_status(:redirect)
    end

    it 'accept access for auth' do
      auth_as(@chat.initiator)
      post :create, params: {chat_id: @chat.id, message: {text: 'Test Message'}}
      expect(response).not_to have_http_status(:redirect)
    end

    it 'denies access if current user not related to chat' do
      user = create(:third_user)
      auth_as(user)
      post :create, params: {chat_id: @chat.id, message: {text: 'Test Message'}}
      expect(response).to have_http_status(:forbidden)
    end

    it 'validates message' do
      auth_as(@chat.initiator)

      post :create, params: {chat_id: @chat.id, message: {text: ''}}
      expect(response.body).to match(/Text can't be blank/)

      text = 'Test Message'
      50.times { text += 'Test Message' }

      post :create, params: {chat_id: @chat.id, message: {text: text}}
      expect(response.body).to match(/Text is too long/)
    end

    it 'saves message' do
      auth_as(@chat.initiator)

      expect {
        post :create, params: {chat_id: @chat.id, message: {text: 'Test Message'}}
      }.to change(Message, :count).by(1)
    end

    it "add chat's users to unread_users association of the new message" do
      auth_as(@chat.initiator)
      post :create, params: {chat_id: @chat.id, message: {text: 'Test Message'}}

      expect(response).to have_http_status(:success)
      expect(Message.last.unread_users.count).to eq(2)
    end
  end
end
