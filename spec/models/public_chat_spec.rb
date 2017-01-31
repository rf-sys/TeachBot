require 'rails_helper'

RSpec.describe PublicChat, type: :model do
  it 'finds public_chat' do
    user = create(:user)
    public_chat = create(:chat, initiator: user, recipient: user, public_chat: true)
    expect(PublicChat.count).to eq(1)
    expect(PublicChat.take.id).to eq(public_chat.id)
  end
end
