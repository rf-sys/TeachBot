require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'DELETE #destroy' do
    it 'denies if foreign use try delete post' do
      post = create(:post)
      foreign_user = create(:second_user)

      auth_as(foreign_user)

      delete :destroy, params: {id: post.id}
      expect(response).to have_http_status(302)

      set_json_request

      delete :destroy, params: {id: post.id}
      expect(response).to have_http_status(403)
      expect(response.body).to match('Access denied')
    end
  end

end
