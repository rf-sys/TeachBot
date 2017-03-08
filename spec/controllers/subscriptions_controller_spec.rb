require 'rails_helper'

RSpec.describe SubscriptionsController, type: :controller do
  before(:each) do
    @course = create(:course)
    @user = create(:second_user)
  end
  describe 'POST #create' do
    it 'requires user' do
      post :create, params: { id: @course.id }
      expect(response).to have_http_status(302)
      set_json_request
      post :create, params: { id: @course.id }
      expect(response).to have_http_status(403)
    end

    it 'subscribes user to course' do
      auth_as(@user)
      post :create, params: { id: @course.id }
      expect(response).to have_http_status(200)
      @user.reload
      expect(@user.subscriptions_to_courses.size).to eq(1)
    end

    it 'denies action if user already subscribed' do
      auth_as(@user)
      @user.subscriptions_to_courses << @course
      @user.reload
      post :create, params: { id: @course.id }
      expect(response).to have_http_status(302)
      set_json_request
      post :create, params: { id: @course.id }
      expect(response).to have_http_status(403)
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user.subscriptions_to_courses << @course
      expect(@user.subscriptions_to_courses.size).to eq(1)
    end

    it 'requires user' do
      delete :destroy, params: {id: @course.id }
      expect(response).to have_http_status(302)
      set_json_request
      delete :destroy, params: {id: @course.id }
      expect(response).to have_http_status(403)
    end

    it 'unsubscribe user' do
      auth_as(@user)
      delete :destroy, params: {id: @course.id }
      expect(response).to have_http_status(200)
      expect(@user.subscriptions_to_courses.size).to eq(0)
    end
  end

end
