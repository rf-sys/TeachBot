require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  describe 'POST #attachment' do
    render_views

    before(:each) do
      auth_as(create(:user))
      set_json_request
    end

    it 'raises error if url is invalid' do
      post :attachment, params: { url: 'http://asdafgds.com/' }
      expect(response).to have_http_status(403)
      expect(response.body).to match(/Resource is invalid or unavailable/)
    end

    it 'returns attachment if everything is ok' do
      post :attachment, params: { url: 'https://google.com/' }
      expect(response).to have_http_status(200)
      expect(response.content_type).to eq('application/json')
    end
  end
end
