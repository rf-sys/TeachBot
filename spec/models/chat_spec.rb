require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe '#between_users' do
    it 'returns chat between initiator and recipient users' do
      user = create(:user)

     5.times do |i|
       another_user = create(:user, username: 'TestUser_' + i.to_s, email: "testuser_#{i}@gmail.com")
       chat = create(:chat, initiator: user, recipient: another_user)
       chat.users << [user, another_user]
     end

      Chat.first.users << create(:user, username: 'TestUser_third', email: 'testuser_third@gmail.com')

      expect(Chat.first.users.count).to eq(3)

      another_user = User.find(2)

      chat = Chat.between_users(user, another_user).take

      expect(chat.present?).to eq(false)

      Chat.first.users.delete(User.find_by_username('TestUser_third'))

      chat = Chat.between_users(user, another_user).take

      expect(chat.present?).to eq(true)
    end
  end
end
