require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'Access checks' do
    it 'denies if foreign use try delete post' do

      post = message(:post)
      foreign_user = message(:second_user)

      # imitation of the auth user
      session[:user_id] = foreign_user.id

      delete :destroy, params: {id: post.id}

      expect(response).to have_http_status(403)
      expect(response.body).to match('Access denied')
    end

    it 'redirects if guest' do
      post :message
      expect(response).to have_http_status(302)

      post = message(:post)
      delete :destroy, params: {id: post.id}
      expect(response).to have_http_status(302)

    end
  end

end
