require 'rails_helper'

RSpec.describe AccountActivationsController, :type => :controller do
  before :each do
    @user = User.create(:username => 'Oki', :email => 'user@test.com', :password => 'password')
    @request.host = 'localhost:3000'
    assert_equal false, @user.activated?
  end

  describe 'GET #edit' do
    it 'it changes activation status and sign in' do
      get :edit, params: {id: @user.activation_token, email: @user.email}
      @user.reload
      assert session[:user_id].present?
      assert_equal true, @user.activated?
    end

    it "it doesn't change activation status and not sign in if invalid token" do
      get :edit, params: {id: 'Invalid token', email: @user.email}
      @user.reload
      assert_nil session[:user_id]
      assert_equal false, @user.activated?
    end
  end
end