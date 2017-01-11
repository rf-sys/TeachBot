require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MessagesHelper. For example:
#
# describe MessagesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe MessagesHelper, type: :helper do
  describe '#users_exclude_current' do
    it 'removes user from array of users' do
      5.times do |i|
        create(:user, username: 'TestUser_' + i.to_s, email: "testuser_#{i}@gmail.com")
      end

      users = User.all
      user = User.last

      expect(users.count).to eq(5)
      expect(user.username).to eq('TestUser_4') # 0 - start index
      expect(users.include?(user)).to eq(true)

      users_without_user = users_exclude_current(users, user)

      expect(users_without_user.count).to eq(4)
      expect(users_without_user.include?(user)).to eq(false)
    end
  end

  describe '#check_if_read' do
    it "returns true if message isn't presented in user's unread_messages" do
      message = create(:message_with_associations)
      user = message.user

      read = check_if_read(message, user)

      expect(read).to eq(true)
    end

    it "returns false if message is presented in user's unread_messages" do
      message = create(:message_with_associations)
      user = message.user
      user.unread_messages << message

      read = check_if_read(message, user)

      expect(read).to eq(false)
    end
  end

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
