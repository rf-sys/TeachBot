require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe '#between_users' do
    it 'returns chat between initiator and recipient' do
      user = create(:user)
      second_user = create(:second_user)

      # create chat between two users
      chat = Chat.create(initiator: user, recipient: second_user, public_chat: false)

      expect(Chat.between_users(user, second_user).take).to eq chat
    end
  end
end
