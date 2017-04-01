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
      initiator = create(:user)
      recipient = create(:second_user)
      auth_as(initiator)
      post :create, params: {user_id: recipient.id, message: {text: 'Test message'}}
      expect(response).to have_http_status(:success)
    end

    it 'returns error when message validation fail' do
      initiator = create(:user)
      recipient = create(:second_user)

      auth_as(initiator)

      post :create, params: { user_id: recipient.id, message: { text: ''  } }
      expect(response.body).to match(/Text can't be blank/)

      text = 'Test Message'
      50.times { text += 'Test Message' }

      post :create, params: { user_id: recipient.id, message: { text: text  } }
      expect(response.body).to match(/Text is too long/)
    end

    it 'returns error if recipient of the message not found' do
      auth_as(create(:user))

      post :create, params: { user_id: 123456, message: {text: 'Test Message'} }
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
  describe 'POST #unread_messages_count' do
    it 'returns count of unread messages equals 0 if no unread messages' do
      user = create(:user)
      auth_as(user)
      post :unread_messages_count
      expect(response.status).to eq(200)
      expect(response.content_type).to eq 'application/json'
      expect(response.body).to match({count: 0}.to_json)
    end


    it 'returns count, equals unread messages' do
      chat = create(:chat)
      user = chat.initiator
      message = create(:message, chat: chat, user: user)

      auth_as(user)

      user.unread_messages << [message]
      expect(user.unread_messages.count).to eq 1
      unread_messages_request(1)

      user.unread_messages << [message]
      expect(user.unread_messages.count).to eq 2
      unread_messages_request(2)
    end

    it 'denies access for guests' do
      post :unread_messages_count
      expect(response.status).to eq(302)
    end
  end

  describe 'POST #mark_as_read' do
    it 'marks message as read' do
      chat = create(:chat)
      user = chat.initiator
      auth_as(user)
      message = create(:message, chat: chat)
      assert_equal user.unread_messages.include?(message), false
      user.unread_messages << message
      assert_equal user.unread_messages.include?(message), true

      post :mark_as_read, params: { id: message.id }

      expect(response).to have_http_status(:success)
      assert_equal user.unread_messages.include?(message), false
    end

    it 'denies access for no auth user' do
      post :mark_as_read, params: { id: 123 }
      expect(response).to have_http_status(302)
    end
  end


  describe 'POST #mark_all_as_read' do
    it 'denies access for guests' do
      post :mark_all_as_read
      expect(response.status).to eq(302)
    end

    it 'deletes unread_messages from DB' do
      message = create_and_set_unread_message
      expect(message.user.unread_messages).to match_array([message])

      auth_as(message.user)

      post :mark_all_as_read, params: {chat_id: message.chat.id}
      expect(message.user.unread_messages.count).to eq(0)
      expect(response.status).to eq(200)
    end

    it 'deletes unread messages of particular user' do
      chat = create(:chat)
      initiator = chat.initiator
      recipient = chat.recipient

      # send messages from initiator to recipient
      5.times do |i|
        message = create(:message, chat: chat, user: initiator, text: 'TestMessage1_' + i.to_s)
        recipient.unread_messages << message
      end

      # send messages from recipient to initiator
      5.times do |i|
        message = create(:message, chat: chat, user: recipient, text: 'TestMessage2_' + i.to_s)
        initiator.unread_messages << message
      end

      expect(Message.all.count).to eq(10)
      expect(recipient.unread_messages.count).to eq(5)
      expect(initiator.unread_messages.count).to eq(5)

      auth_as(recipient)

      post :mark_all_as_read, params: {chat_id: chat.id}

      expect(Message.all.count).to eq(10)
      expect(recipient.unread_messages.count).to eq(0)
      expect(initiator.unread_messages.count).to eq(5)

      expect(response.status).to eq(200)

    end
  end

  describe 'POST #unread_messages' do
    it 'displays unread messages' do
      chat = create(:chat)
      user = chat.initiator
      auth_as(user)

      unread_message = create(:message, chat: chat)
      create(:message, chat: chat)

      user.unread_messages << unread_message

      set_json_request
      post :unread_messages, params: { chat_id: chat.id }

      expect(response).to have_http_status(:success)

      expect(chat.messages.count).to eq 2
      expect(user.unread_messages.count).to eq 1
    end
  end


  private

  def unread_messages_request(count)
    post :unread_messages_count
    expect(response.status).to eq(200)
    expect(response.content_type).to eq 'application/json'

    expect(response.body).to match({count: count}.to_json)
  end

  def create_and_set_unread_message
    message = create(:message_with_associations)
    message.user.unread_messages << message
    message
  end

end
