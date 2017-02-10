require 'rails_helper'

RSpec.describe PublicChatController, type: :controller do
  describe 'GET #show' do
    it 'denies access for guest' do
      get :show
      expect(response).to have_http_status(302)
    end

    it 'returns success for auth user' do
      user = create(:user)
      auth_as(user)
      get :show
      expect(response).to have_http_status(200)
    end
  end

end
