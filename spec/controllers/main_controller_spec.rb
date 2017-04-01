require 'rails_helper'

RSpec.describe MainController, type: :controller do
  include SessionsHelper
  describe 'GET #index' do
    before(:each) do
      @user = create(:user)
    end
    it 'sign me in if I has cookie and valid remember token' do
      remember(@user)
      get :index
      expect(session[:user_id].present?).to be true
      expect(session[:user_id]).to eq @user.id
    end

    it 'not signs me in if I have invalid user_id cookie' do
      remember(@user)
      cookies.signed[:user_id] = 'invalid'

      get :index
      expect(session[:user_id].present?).to be false
    end

    it 'not signs me in if I have invalid remember_token cookie' do
      remember(@user)
      cookies.signed[:remember_token] = 'invalid'

      get :index
      expect(session[:remember_token].present?).to be false
    end
  end
end
