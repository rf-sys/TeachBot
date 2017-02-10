require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  describe 'POST #add_participant' do
    it 'adds new participant' do
      chat = create_chat_and_participants
      third_user = create(:third_user)
      auth_as(chat.initiator)

      post :add_participant, params: {id: chat.id, user_id: third_user.id}
      expect(response).to have_http_status(200)
    end

    it 'denies access if current_user is not author of the chat' do
      chat = create_chat_and_participants
      third_user = create(:third_user)
      auth_as(third_user)

      post :add_participant, params: {id: chat.id, user_id: third_user.id}
      expect(response).to have_http_status(302)
    end

    it 'denies access if given user is already in the chat' do
      chat = create_chat_and_participants
      auth_as(chat.recipient)
      post :add_participant, params: {id: chat.id, user_id: chat.recipient_id}
      expect(response).to have_http_status(302)
    end

    it 'denies access if no auth' do
      chat = create_chat_and_participants
      post :add_participant, params: {id: chat.id, user_id: nil}
      expect(response).to have_http_status(302)
    end

  end

  describe 'DELETE #kick_participant' do
    it 'kicks a participant' do
      chat = create_chat_and_participants
      auth_as(chat.initiator)

      delete :kick_participant, params: {id: chat.id, user_id: chat.recipient_id}
      expect(response).to have_http_status(200)
      expect(response.body).to match(/success/)
    end

    it 'denies access if current_user is not author of the chat', js: true do
      chat = create_chat_and_participants
      auth_as(chat.recipient)

      delete :kick_participant, params: {id: chat.id, user_id: chat.recipient_id}
      expect(response).to have_http_status(302)

      set_json_request

      delete :kick_participant, params: {id: chat.id, user_id: chat.recipient_id}
      expect(response).to have_http_status(403)
      expect(response.body).to match(/You are not an author of the conversation/)
    end

    it 'denies access if no auth' do
      chat = create_chat_and_participants
      delete :kick_participant, params: {id: chat.id, user_id: chat.recipient_id}
      expect(response).to have_http_status(302)

      set_json_request

      delete :kick_participant, params: {id: chat.id, user_id: chat.recipient_id}
      expect(response).to have_http_status(403)
      expect(response.body).to match(/You need login to go there/)
    end

    it 'denies access if author tries to kick yourself' do
      chat = create_chat_and_participants
      auth_as(chat.initiator)
      delete :kick_participant, params: {id: chat.id, user_id: chat.initiator_id}
      expect(response).to have_http_status(302)

      set_json_request

      delete :kick_participant, params: {id: chat.id, user_id: chat.initiator_id}
      expect(response).to have_http_status(403)
      expect(response.body).to match(/Author cannot kick yourself/)

    end

  end

  private

  def create_chat_and_participants
    chat = create(:chat)
    chat.users << [chat.initiator, chat.recipient]
    chat
  end
end
