require 'rails_helper'

RSpec.describe MessagesController, type: :controller do
  describe 'POST #create - create or get chat and save message to there' do
    before :each do
      set_json_request # POST #create expects only json response
    end

    it 'denied access for guests' do
      post :create
      expect(response).to have_http_status(403)
    end

    it 'accept access for auth' do
      auth_as(create(:user))

      post :create
      expect(response).not_to have_http_status(:redirect) # returns no matter what error, but no redirect
    end

    it 'returns error when message validation fail' do
      initiator = create(:user)
      recipient = create(:second_user)

      auth_as(initiator)

      post :create, params: { user_id: recipient, message: { text: ''  } }
      expect(response.body).to match(/Text can't be blank/)

      text = 'Test Message'
      50.times { text += 'Test Message' }

      post :create, params: { user_id: recipient, message: { text: text  } }
      expect(response.body).to match(/Text is too long/)
    end

    it 'returns error if recipient of the message not found' do
      auth_as(create(:user))

      post :create, params: { user_id: 123456 }
      expect(response).to have_http_status(:not_found)
      expect(response.body).to match(/Recipient not found/)
    end

    it 'creates a new chat between users if not found' do
      initiator = create(:user)
      recipient = create(:second_user)
      auth_as(initiator)

      expect {
        post :create, params: { user_id: recipient.id, message: {text: 'Test message'} }
      }.to change(Chat, :count).by(1)
    end

    it 'gets existing chat between users if found' do
      # @type [Chat]
      chat = create(:chat)
      initiator = chat.initiator
      recipient = chat.recipient

      auth_as(initiator)

      post :create, params: { user_id: recipient.id, message: { text: 'New message' }}

      expect {
        post :create, params: { user_id: recipient.id, message: {text: 'Test message'} }
      }.to change(Chat, :count).by(0)


    end
  end

end
