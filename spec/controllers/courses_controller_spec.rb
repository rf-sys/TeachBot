require 'rails_helper'

RSpec.describe CoursesController, :type => :controller do
  include ActiveJob::TestHelper
  before :each do
    @course = create(:course)
    @redis = Redis.new
    @redis.flushall
  end
  describe 'GET #show' do
    it 'add views' do
      expect {
        get :show, params: { id: @course.friendly_id }
        expect(response).to have_http_status(:success)
      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end
  end

  describe 'PATCH #update_poster' do
    it 'do redirect if guest' do
      patch :update_poster, params: { id: @course.id }
      expect(response.status).to eq(302)
    end

    it 'denies access for foreign user' do
      foreign_user = create(:second_user)
      foreign_user.add_role(:teacher)

      auth_as(foreign_user)

      patch :update_poster, params: { id: @course.id }
      expect(response.status).to eq(302)

      set_json_request

      patch :update_poster, params: { id: @course.id }
      expect(response.status).to eq(403)
      expect(response.body).to match(/Access denied/)
    end

    it 'returns error if file is not presented' do
      auth_as(@course.author)

      patch :update_poster, params: { id: @course.id }
      expect(response.status).to eq(302)

      set_json_request

      patch :update_poster, params: { id: @course.id }
      expect(response.status).to eq(422)
      expect(response.body).to match(/File not found/)
    end

    it 'returns error if file is invalid' do
      auth_as(@course.author)

      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'file.txt'), 'image/png')
      patch :update_poster, params: { id: @course.id, course: { poster: file } }
      expect(response.status).to eq(422)
      expect(response.body).to match(/Impossible to get width of the file/)
    end

    it 'returns appropriate error message if the file is too height' do
      auth_as(@course.author)
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'too_height_poster.jpg'), 'image/png')
      patch :update_poster, params: { id: @course.id, course: { poster: file } }
      expect(response.status).to eq(422)
      expect(response.body).to match(/Height is too high/)
    end

    it 'returns appropriate error message if the file is too width' do
      auth_as(@course.author)
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'too_width_poster.jpg'), 'image/png')
      patch :update_poster, params: { id: @course.id, course: { poster: file } }
      expect(response.status).to eq(422)
      expect(response.body).to match(/Width is too high/)
    end

    it 'returns success if file is valid' do
      auth_as(@course.author)

      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'valid_poster.jpg'), 'image/png')
      patch :update_poster, params: { id: @course.id, course: { poster: file } }
      expect(response.body).to match(/Poster has been created successfully/)
      expect(response.status).to eq(200)

    end
  end
end