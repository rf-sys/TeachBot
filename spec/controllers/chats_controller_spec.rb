require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  describe 'POST #add_participant' do
    it 'adds new participant' do
      chat = create(:chat)
      third_user = create(:third_user)
      auth_as(chat.initiator)

      post :add_participant, params: { id: chat.id, user_id: third_user.id }
      expect(response).to have_http_status(200)
    end

    it 'denies access if current_user is not author of the chat' do
      chat = create(:chat)
      third_user = create(:third_user)
      auth_as(third_user)

      post :add_participant, params: { id: chat.id, user_id: third_user.id }
      expect(response).to have_http_status(302)
    end

    it 'denies access if given user is already in the chat' do
      chat = create(:chat)
      auth_as(chat.initiator)
      post :add_participant, params: { id: chat.id, user_id: chat.recipient_id }
      expect(response).to have_http_status(302)
      set_json_request
      post :add_participant, params: { id: chat.id, user_id: chat.recipient_id }
      expect(response).to have_http_status(403)
      expect(response.body).to match(/User is already in chat/)
    end

    it 'denies access if no auth' do
      chat = create(:chat)
      post :add_participant, params: {id: chat.id, user_id: nil}
      expect(response).to have_http_status(302)
    end

  end

  describe 'DELETE #leave' do
    it 'removes participant from the chat' do
      chat = create(:chat)
      chat.users << create(:third_user)

      assert_equal(chat.users.count, 3)
      auth_as(chat.recipient)
      delete :leave, params: { id: chat.id }
      expect(response).to have_http_status(:success)
      expect(chat.users.count).to eq 2
    end

    it 'removes chat if only one participant left' do
      chat = create(:chat)
      assert_equal(chat.users.count, 2)
      auth_as(chat.recipient)

      delete :leave, params: { id: chat.id }
      expect(response).to have_http_status(:success)
      expect(Chat.exists?(chat.id)).to eq false
    end
  end

  describe 'DELETE #kick_participant' do
    it 'kicks a participant' do
      chat = create(:chat)
      auth_as(chat.initiator)

      delete :kick_participant, params: {id: chat.id, user_id: chat.recipient_id}
      expect(response).to have_http_status(200)
      expect(response.body).to match(/success/)
    end

    it 'denies access if current_user is not author of the chat', js: true do
      chat = create(:chat)
      auth_as(chat.recipient)

      delete :kick_participant, params: {id: chat.id, user_id: chat.recipient_id}
      expect(response).to have_http_status(302)

      set_json_request

      delete :kick_participant, params: {id: chat.id, user_id: chat.recipient_id}
      expect(response).to have_http_status(403)
      expect(response.body).to match(/You are not an author of the conversation/)
    end

    it 'denies access if no auth' do
      chat = create(:chat)
      delete :kick_participant, params: {id: chat.id, user_id: chat.recipient_id}
      expect(response).to have_http_status(302)

      set_json_request

      delete :kick_participant, params: {id: chat.id, user_id: chat.recipient_id}
      expect(response).to have_http_status(403)
      expect(response.body).to match(/You need login to go there/)
    end

    it 'denies access if author tries to kick yourself' do
      chat = create(:chat)
      auth_as(chat.initiator)
      delete :kick_participant, params: {id: chat.id, user_id: chat.initiator_id}
      expect(response).to have_http_status(302)

      set_json_request

      delete :kick_participant, params: {id: chat.id, user_id: chat.initiator_id}
      expect(response).to have_http_status(403)
      expect(response.body).to match(/Author cannot kick yourself/)

    end

  end
end
