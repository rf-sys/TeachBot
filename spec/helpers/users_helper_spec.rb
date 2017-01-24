require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
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
end
