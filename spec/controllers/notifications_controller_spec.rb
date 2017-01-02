require 'rails_helper'

RSpec.describe NotificationsController, type: :controller do

  before :each do
    @notification = create(:notification)
  end

  describe 'DELETE #destroy' do
    it 'returns Ok if all is valid' do
      auth_user
      delete_request
      expect(response).to have_http_status(:success)
      expect(response.body).to match(/Ok/)
    end

    it 'returns 403 if user is not auth' do
      delete_request
      expect(response).to have_http_status(:forbidden)
      expect(response.body).to match(/Forbidden/)
    end

    it 'returns 404 if notification not found' do
      auth_user
      delete :destroy, params: { id: @notification.id + 1}
      expect(response).to have_http_status(:not_found)
      expect(response.body).to match(/Notification not found/)
    end
  end



  private
  def auth_user
    session[:user_id] = @notification.user.id
  end

  def delete_request
    delete :destroy, params: { id: @notification.id}
  end

end
