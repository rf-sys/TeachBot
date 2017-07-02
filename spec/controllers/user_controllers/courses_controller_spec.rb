require 'rails_helper'

RSpec.describe UserControllers::CoursesController, type: :controller do
  before(:each) do
    @user = create(:user)
  end
  describe 'GET #index' do
    it 'renders courses of the user' do
      get :index, params: { user_id: @user.id }
      expect(response).to have_http_status(:success)

      set_json_request

      get :index, params: { user_id: @user.id }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @course = create(:course, author: @user)
    end

    it 'denies access for guests' do
      delete :destroy, params: { user_id: @user.id, id: @course.id }
      expect(response).to have_http_status(302)

      set_json_request

      delete :destroy, params: { user_id: @user.id, id: @course.id }
      expect(response).to have_http_status(403)
      expect(response.body).to match(/You need login to go there/)

    end

    it 'denies access no owner' do
      auth_as(create(:second_user))
      delete :destroy, params: { user_id: @user.id, id: @course.id }
      expect(response).to have_http_status(403)
      expect(response.body).to match(/Forbidden/)

    end

    it 'deletes course' do
      auth_as(@user)
      delete :destroy, params: { user_id: @user.id, id: @course.id }
      expect(response).to have_http_status(200)

      expect(Course.exists?(@course.id)).to be false
    end
  end
end
