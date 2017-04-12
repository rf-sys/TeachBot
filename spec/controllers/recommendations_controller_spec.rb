require 'rails_helper'

RSpec.describe RecommendationsController, type: :controller do

  describe 'GET #index' do
    it 'denies access for guests' do
      get :index
      expect(response).to have_http_status(302)
    end

    it 'accepts access for auth users' do
      auth_as(create(:user))
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
