require 'rails_helper'

require 'services/uploaders/local_uploader'

class TestLocalUploader < LocalUploader
  def extension
    File.extname(@file).delete('.')
  end

  def file_path
    'spec/tmp'
  end
end

describe 'local_uploader' do
  context 'save file' do
    it 'saves file' do
      file = Rails.root.join('spec/fixtures/files', 'file.txt')

      file_uploader = TestLocalUploader.new(file, 'test_file')
      file_uploader.store
      expect(File.exist?('spec/tmp/test_file.txt')).to be true
    end
  end
end
