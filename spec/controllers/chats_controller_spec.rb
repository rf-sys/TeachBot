require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  describe 'GET #public_chat' do
    it 'is forbidden for guests' do
      create(:chat) # id = 1
      get :public_chat
      expect(response).to have_http_status(:redirect)
    end

    it 'is success for auth users' do
      # @type [Chat] public_chat
      public_chat = create(:chat)

      auth_user_as(public_chat.initiator) # just to get User that exists

      get :public_chat
      expect(response).to have_http_status(:success)
    end
  end
end
