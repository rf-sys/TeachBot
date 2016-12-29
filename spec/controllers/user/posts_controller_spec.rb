require 'rails_helper'

RSpec.describe User::PostsController, type: :controller do

  describe 'GET #index' do
    before :each do
      @post = message(:post)

      get :index, params: {user_id: @post.user_id}
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns collection of the posts' do
      expect(response.body).to match(@post.title)
    end
  end

end
