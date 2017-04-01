require 'rails_helper'

RSpec.describe MessagesHelper, type: :helper do
  describe '#read?' do
    it "returns true if message isn't presented in user's unread_messages" do
      message = create(:message_with_associations)
      user = message.user

      read = read?(message, user)

      expect(read).to eq(true)
    end

    it "returns false if message is presented in user's unread_messages" do
      message = create(:message_with_associations)
      user = message.user
      user.unread_messages << message

      read = read?(message, user)

      expect(read).to eq(false)
    end
  end

  describe '#chat_unread_messages' do
    it "adds unread message to user's unread_messages list" do
      chat = create(:chat)

      message = create(:message_with_associations,
                       chat: chat, user: chat.initiator)

      user = chat.initiator

      user.unread_messages << message

      unread_messages = chat_unread_messages(user, chat.id)

      expect(unread_messages.count).to be 1
    end
  end
end
