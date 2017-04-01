require 'rails_helper'

RSpec.describe User, type: :model do
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

  describe '#remember' do
    it 'creates remember token' do
      user = create(:user)

      expect(user.remember_token).to eq nil

      user.remember

      user.reload

      expect(user.remember_token).not_to eq nil
    end
  end

  describe '#authenticated?' do
    before(:each) do
      @user = create(:user)
    end
    it 'returns true if password matches the digest' do
      expect(@user.authenticated?(:password, @user.password)).to be true
    end

    it 'returns false if password not matches the digest' do
      expect(@user.authenticated?(:password, 'random_password')).to be false
    end

    it 'returns true if activation token and digest are match' do
      activation_token = User.new_token
      activation_digest = User.digest(activation_token)

      @user.update(activation_digest: activation_digest)

      @user.reload

      expect(@user.authenticated?(:activation, activation_token)).to be true
    end

    it 'returns false if activation token and digest are not match' do
      activation_token = User.new_token
      activation_digest = User.digest(activation_token)

      @user.update(activation_digest: activation_digest)

      @user.reload

      expect(@user.authenticated?(:activation, 'invalid_token')).to be false
    end
  end

  describe '#activate' do
    it 'activates account' do
      user = create(:user, activated: false)

      expect(user.activated).to be false
      expect(user.activated_at).to be nil

      user.activate
      user.reload

      expect(user.activated).to be true
      expect(user.activated_at).not_to be nil
    end
  end

  describe '#find_or_create_from_auth_hash' do
    it 'can find existing oauth user' do
      user = create(:user, provider: 'facebook', uid: SecureRandom.base58)
      hash = { provider: user.provider, uid: user.uid }

      found_user = User.find_or_create_from_auth_hash(hash)
      expect(found_user.id).to eq user.id
    end

    it 'creates new oauth user if no found' do
      user = create(:user)
      hash = {
        provider: 'facebook',
        uid:      SecureRandom.base58,
        info:     {
          name:   'FacebookTestName',
          email:  'FacebookTestEmail@gmail.com',
          avatar: 'FacebookTestAvatar'
        }
      }

      found_user = User.find_or_create_from_auth_hash(hash)

      expect(found_user.id).not_to eq user.id
    end
  end
end
