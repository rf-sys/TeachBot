require 'rails_helper'

RSpec.describe PostersController, type: :controller do
  describe 'PATCH/PUT #update' do
    it 'do redirect if guest' do
      course = create(:course)
      put :update, params: {course_id: course.id}
      expect(response.status).to eq(302)
    end

    it 'denies access for foreign user' do
      course = create(:course)

      foreign_user = create(:second_user)

      session[:user_id] = foreign_user.id

      put :update, params: {course_id: course.id}
      expect(response.status).to eq(403)
      expect(response.body).to match(/Access denied/)
    end

    it 'returns error if file is not presented' do
      course = create(:course)
      session[:user_id] = course.author.id

      put :update, params: {course_id: course.id}
      expect(response.status).to eq(422)
      expect(response.body).to match(/File not found/)
    end

    it 'returns error if file is invalid' do
      course = create(:course)
      session[:user_id] = course.author.id


      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'file.txt'), 'image/png')

      put :update, params: {course_id: course.id, course: {poster: file}}

      expect(response.status).to eq(422)
      expect(response.body).to match(/File has no valid type/)
    end

    it 'returns success if file is valid' do
      course = create(:course)
      session[:user_id] = course.author.id


      file = fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'valid_poster.jpg'), 'image/png')

      put :update, params: {course_id: course.id, course: {poster: file}}

      expect(response.status).to eq(200)
      expect(response.body).to match(/Poster has been created successfully/)
    end
  end
end
