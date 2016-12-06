require 'rails_helper'

RSpec.describe User, :type => :model do
  it "doesn't creates user with invalid data" do
    user = build(:user, email: 'indvalid.com')
    expect(user.save).to eq(false)

    user = build(:user, username: '')
    expect(user.save).to eq(false)

    user = build(:user, username: SecureRandom.hex(60))
    expect(user.save).to eq(false)
  end

  it 'creates valid user' do
    user = build(:user)
    expect(user.save).to eq(true)
  end
end