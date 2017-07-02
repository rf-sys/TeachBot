require 'rails_helper'

RSpec.describe Message, type: :model do
  describe '#for_chat' do
    it 'returns messages for specific chat' do
      user = create(:user)
      second_user = create(:second_user)

      first_chat = create(:chat, initiator: user, recipient: user)

      second_chat = create(:chat, initiator: user, recipient: second_user)

      create(:message_with_associations, chat: first_chat)

      expect(Message.for_chat(first_chat).count).to be 1
      expect(Message.for_chat(second_chat).count).to be 0
    end
  end
end
