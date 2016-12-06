require 'rails_helper'

RSpec.describe User, :type => :model do
  it "doesn't creates user with invalid data" do
    user = User.create(username: 'TestUser', email: 'INVALIDMAIL.com', password: 'password')
    expect(user.persisted?).to eq(false)

    user = User.create(username: '', email: 'test@gmail.com', password: 'password')
    expect(user.persisted?).to eq(false)

    user = User.create(username: SecureRandom.hex(60), email: 'test@gmail.com', password: 'password')
    expect(user.persisted?).to eq(false)

  end
end