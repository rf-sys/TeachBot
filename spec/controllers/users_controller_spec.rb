require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  include ActiveJob::TestHelper

  describe 'GET #show' do
    it 'returns user' do
      user = create(:user)

      get :show, params: { id: user.slug }

      expect(response).to have_http_status(200)
      expect(assigns(:user)).to eq(user)
    end
  end

  describe 'POST #create' do
    it 'adds confirmation email into job queue' do
      expect do
        post :create, params: { user: FactoryGirl.attributes_for(:user) }
      end.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end

    it 'creates user' do
      expect do
        post :create, params: { user: FactoryGirl.attributes_for(:user) }
      end.to change(User, :count).by(1)
    end

    it 'returns validation errors' do
      post :create, params: {
        user: {
          username:              '',
          email:                 '',
          password:              '',
          password_confirmation: ''
        }
      }
      expect(response).to have_http_status(422)

      expect(response.body).to match(/Username can't be blank/)
      expect(response.body).to match(/Email is not an email/)
      expect(response.body).to match(/Password is too short/)
      expect(response.body).to match(
        /Password confirmation doesn't match Password/
      )
    end

    it 'does not save invalid user' do
      expect do
        post :create, params: {
          user: {
            username:              '',
            email:                 '',
            password:              '',
            password_confirmation: ''
          }
        }
        expect(response).to have_http_status(422)
      end.to change(User, :count).by(0)
    end
  end

  describe 'PUT/PATCH #update' do
    before(:each) do
      @user = create(:user)
    end
    it 'updates user' do
      auth_as(@user)
      patch :update, params: {
        id:   @user.friendly_id,
        user: {
          username:           'updated_username',
          profile_attributes: {
            about: 'Test user about',
            id:    @user.id
          }
        }
      }
      @user.reload

      expect(response).to have_http_status(302)
      expect(@user.username).to eq('updated_username')
      expect(@user.profile.about).to eq('Test user about')
    end

    it 'returns error if invalid credentials' do
      auth_as(@user)
      patch :update, params: {
        id:   @user.friendly_id,
        user: {
          username: ''
        }
      }
      expect(response).to have_http_status(422)
    end

    it 'updates avatar' do
      auth_as(@user)
      avatar = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'valid_avatar.jpg'),
                                   'image/png')

      default_avatar = @user.avatar

      patch :update, params: {
        id:   @user.friendly_id,
        user: {
          username: 'updated_username',
          avatar:   avatar
        }
      }

      @user.reload
      expect(response).to have_http_status(302)
      expect(@user.avatar).not_to eq default_avatar
      expect(@user.avatar).to match(/teachbot-test.s3/)
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @user = create(:user)
    end

    it 'denies for guests' do
      delete :destroy, params: { id: @user.friendly_id }
      expect(response).to have_http_status(302)

      set_json_request

      delete :destroy, params: { id: @user.friendly_id }
      expect(response).to have_http_status(403)
      expect(response.body).to match(/You need login to go there/)

      expect(User.exists?(@user.id)).to be true
    end

    it 'denies access for foreign user' do
      second_user = create(:second_user)
      auth_as(second_user)

      delete :destroy, params: { id: @user.friendly_id }
      expect(response).to have_http_status(302)

      set_json_request

      delete :destroy, params: { id: @user.friendly_id }
      expect(response).to have_http_status(403)
      expect(response.body).to match(/Access denied/)

      expect(User.exists?(@user.id)).to be true
    end

    it 'deletes current user' do
      auth_as(@user)

      delete :destroy, params: { id: @user.friendly_id }
      expect(response).to have_http_status(302)
      expect(User.exists?(@user.id)).to be false
    end
  end
end
