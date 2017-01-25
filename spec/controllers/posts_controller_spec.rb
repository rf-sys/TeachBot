require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'Access checks' do
    it 'denies if foreign use try delete post' do

      post = create(:post)
      foreign_user = create(:second_user)

      # imitation of the auth user
      auth_as(foreign_user)

      delete :destroy, params: {id: post.id}

      expect(response).to have_http_status(403)
      expect(response.body).to match('Access denied')
    end

    it 'redirects if guest' do
      post :create
      expect(response).to have_http_status(302)

      post = create(:post)
      delete :destroy, params: {id: post.id}
      expect(response).to have_http_status(302)

    end
  end

end
