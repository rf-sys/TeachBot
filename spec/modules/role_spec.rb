require 'rails_helper'

describe 'Role' do
  before :each do
    # @type [User] user
    @user = create(:user)
  end

  describe 'associations' do
    it 'attaches roles association to the model' do
      collection_class = ActiveRecord::Associations::CollectionProxy
      expect(@user.roles.is_a?(collection_class)).to be true
    end
  end

  describe '#role?' do
    it 'returns true if role exists' do
      assert_equal @user.role?('user'), true
    end

    it 'returns false if role is absent' do
      assert_equal @user.role?('admin'), false
    end
  end

  describe '#add_role' do
    it 'attaches role to user' do
      @user.add_role(:admin)
      @user.reload
      expect(@user.roles.size).to be 2
      expect(@user.role?('admin')).to eq true
    end

    it 'deletes previous same role' do
      3.times { @user.add_role(:admin) }
      @user.reload
      expect(@user.roles.size).to be 2
      expect(@user.role?('admin')).to eq true
    end
  end

  describe '#assign_default_role' do
    it 'creates default role' do
      @user.role?('user')
      expect(@user.roles.size).to be 1
    end
  end
end