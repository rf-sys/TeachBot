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
        get :show, params: {id: @course.id}

      }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
    end
  end

  describe 'PATCH #update_poster' do
    it 'do redirect if guest' do
      patch :update_poster, params: {id: @course.id}
      expect(response.status).to eq(302)
    end

    it 'denies access for foreign user' do
      foreign_user = create(:second_user)
      foreign_user.add_role(:teacher)
      session[:user_id] = foreign_user.id
      patch :update_poster, params: {id: @course.id}
      expect(response.status).to eq(403)
      expect(response.body).to match(/Access denied/)
    end

    it 'returns error if file is not presented' do
      session[:user_id] = @course.author.id
      patch :update_poster, params: {id: @course.id}
      expect(response.status).to eq(422)
      expect(response.body).to match(/File not found/)
    end

    it 'returns error if file is invalid' do
      session[:user_id] = @course.author.id
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'file.txt'), 'image/png')
      patch :update_poster, params: {id: @course.id, course: {poster: file}}
      expect(response.status).to eq(422)
      expect(response.body).to match(/File has no valid type/)
    end

    it 'returns success if file is valid' do
      session[:user_id] = @course.author.id
      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'valid_poster.jpg'), 'image/png')
      patch :update_poster, params: {id: @course.id, course: {poster: file}}
      expect(response.status).to eq(200)
      expect(response.body).to match(/Poster has been created successfully/)
    end
  end
end