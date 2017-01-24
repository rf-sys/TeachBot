require 'rails_helper'

RSpec.describe MessagesHelper, type: :helper do
  describe '#check_if_read' do
    it "returns true if message isn't presented in user's unread_messages" do
      message = create(:message_with_associations)
      user = message.user

      read = is_read?(message, user)

      expect(read).to eq(true)
    end

    it "returns false if message is presented in user's unread_messages" do
      message = create(:message_with_associations)
      user = message.user
      user.unread_messages << message

      read = is_read?(message, user)

      expect(read).to eq(false)
    end
  end
end
