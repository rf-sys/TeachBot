require 'rails_helper'
require 'capybara'

RSpec.describe "ProfileTests", type: :request do
  describe "Profile access" do
    before :each do
      @user = User.create(username: 'Oka', email: 'user@test.com', password: 'password')
      post "/login", params: {session: {email: @user.email, password: @user.password}}
      assert_response :redirect
    end

    it "auth user can change own profile" do

      patch "/users/#{@user.id}",
            params: { username: "Civil" },
            xhr: true

      assert_response :success
      @user.reload
      assert 'Civil', @user.username

    end

    it "auth_user cannot change foreign profile" do
      foreign = User.create(username: 'Rodion', email: 'rodion@test.com', password: 'rodion')

      patch "/users/#{foreign.id}",
            params: { username: "FOREIGN" },
            xhr: true

      assert_response :forbidden # 403
      assert_nil User.find_by_username('FOREIGN')

    end

    teardown do
      Rails.cache.clear
    end
  end
end
