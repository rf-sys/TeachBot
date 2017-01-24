require 'rails_helper'

RSpec.describe ChatsHelper, type: :helper do
  describe '#user_related_to_chat' do
    it 'returns true if user is included into the chat' do
      chat = create(:chat)
      chat.users << [chat.initiator, chat.recipient]

      related = user_related_to_chat(chat, chat.initiator)

      expect(related).to eq(true)
    end

    it "returns false if user isn't included into the chat" do
      chat = create(:chat)
      chat.users << [chat.initiator]

      related = user_related_to_chat(chat, chat.recipient)

      expect(related).to eq(false)
    end
  end

end