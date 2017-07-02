require 'rails_helper'

RSpec.describe ChatsHelper, type: :helper do
  describe '#user_related_to_chat' do
    it 'returns true if user is included into the chat' do
      chat = create(:chat)

      related = user_related_to_chat(chat, chat.initiator)

      expect(related).to eq(true)
    end

    it "returns false if user isn't included into the chat" do
      chat = create(:chat)

      foreign_user = create(:third_user)

      related = user_related_to_chat(chat, foreign_user)

      expect(related).to eq(false)
    end
  end

end