require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  describe 'POST #create' do
    before(:each) do
      auth_as(create(:user))
      set_json_request
    end

    it 'returns error if empty text' do
      post :create, params: { post: { text: '' } }
      expect(response).to have_http_status(422)
    end

    it 'returns post if only text is presented' do
      post :create, params: { post: { text: 'Test text' } }
      expect(response).to have_http_status(200)
    end

    it 'returns error if invalid attachment url' do
      post :create, params: { post: {
        text:                   'Test text',
        attachments_attributes: [
          {
            title: 'Test attachment',
            type:  'link',
            url:   'http://asdafgds.com/'
          }
        ]
      } }
      expect(response).to have_http_status(403)
    end

    it 'returns error if url is not presented' do
      post :create, params: { post: {
        text:                   'Test text',
        attachments_attributes: [
          {
            title: 'Test attachment',
            type:  'link'
          }
        ]
      } }
      expect(response).to have_http_status(422)
      expect(response.body).to match(/url can't be blank/)
    end

    it 'returns error if attachment is link and do not have a title' do
      post :create, params: { post: {
        text:                   'Test text',
        attachments_attributes: [
          {
            type: 'link',
            url:  'https://google.com/'
          }
        ]
      } }
      expect(response).to have_http_status(422)
      expect(response.body).to match(/title can't be blank/)
    end

    it 'returns error if attachment is image and do not have a image url' do
      post :create, params: { post: {
        text:                   'Test text',
        attachments_attributes: [
          {
            type: 'image'
          }
        ]
      } }
      expect(response).to have_http_status(422)
      expect(response.body).to match(/url can't be blank/)
    end

    it 'returns error if invalid attachment type' do
      post :create, params: { post: {
        text:                   'Test text',
        attachments_attributes: [
          {
            title: 'Test attachment',
            type:  'invlidType',
            url:   'https://google.com/'
          }
        ]
      } }
      expect(response).to have_http_status(422)
      expect(response.body).to match(/is not a valid attachment type/)
    end

    it 'add attachment to post' do
      post :create, params: { post: {
        text:                   'Test text',
        attachments_attributes: [
          {
            title: 'Test attachment',
            type:  'link',
            url:   'https://google.com/'
          }
        ]
      } }
      expect(response).to have_http_status(200)
      expect(Post.count).to be 1
      expect(Attachment.count).to be 1
      expect(Post.first.attachments.count).to be 1
    end
  end

  describe 'DELETE #destroy' do
    it 'denies if foreign use try delete post' do
      post = create(:post)
      foreign_user = create(:second_user)

      auth_as(foreign_user)

      delete :destroy, params: { id: post.id }
      expect(response).to have_http_status(302)

      set_json_request

      delete :destroy, params: { id: post.id }
      expect(response).to have_http_status(403)
      expect(response.body).to match('Access denied')
    end

    it 'deletes post and connected attachments' do
      post = create(:post)
      create(:attachment, :valid_attachment, attachable: post)
      expect(post.attachments.count).to be 1

      auth_as(post.user)

      delete :destroy, params: { id: post.id }
      expect(response).to have_http_status(200)
      expect(Post.count).to eq 0
      expect(Attachment.count).to eq 0

    end
  end
end
