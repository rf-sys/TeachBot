require 'rails_helper'

require 'uploaders/poster_uploader'

describe 'aws_uploader' do
  let(:file) { File.new(Rails.root.join('spec/fixtures/files', 'valid_poster.jpg')) }
  let(:filename) { '1' }
  subject(:uploader) { PosterUploader.new(file, filename) }

  context 'poster' do
    it 'saves poster' do
      expect { uploader.store }.not_to raise_exception
      uploaded_file = $bucket.object("uploads/courses_posters/#{filename}.jpg")
      expect(uploaded_file.exists?).to be true
    end

    it 'catches error' do
      file = nil # as if we try to upload invalid file
      uploader = PosterUploader.new(file, filename)
      expect(uploader.store).to be false

      uploaded_file = $bucket.object("uploads/courses_posters/#{filename}.jpg")
      expect(uploaded_file.exists?).to be false
    end
  end
end
