require 'rails_helper'

require 'services/uploaders/base_uploader'

describe 'base_uploader' do
  let(:file) { File.new(Rails.root.join('spec/fixtures/files', 'valid_poster.jpg')) }
  subject(:uploader) { BaseUploader.new(file, '1.jpg') }

  context 'default values' do
    it 'sets default #available_formats' do
      expect(uploader.available_formats).to eq []
    end

    it 'sets default #max_size' do
      expect(uploader.max_size).to eq 0
    end

    it 'sets default #max_height' do
      expect(uploader.max_height).to eq 0
    end

    it 'sets default #max_width' do
      expect(uploader.max_width).to eq 0
    end

    it 'sets default #extension' do
      expect(uploader.extension).to eq 'jpeg'
    end
  end

  context 'validation' do
    context '#check_formats' do
      it 'passes validation if matches available formats' do
        uploader.define_singleton_method(:available_formats, proc { ['jpeg'] })
        expect { uploader.check_formats }.not_to raise_error
      end

      it 'raise error if no matches available formats' do
        expect { uploader.check_formats }.to raise_error('File has no valid type')
      end
    end

    context '#check_size' do
      it 'passes validation if weight is lower or equal than max_size' do
        uploader.define_singleton_method(:max_size, proc { 2048 })
        expect { uploader.check_size }.not_to raise_error
      end

      it 'raise error if weight is more than max_size' do
        expect { uploader.check_size }.to raise_error(/File is too large/)
      end
    end

    context '#check_width' do
      it 'passes validation if width is lower or equal than max_width' do
        uploader.define_singleton_method(:max_width, proc { 1536 })
        expect { uploader.check_width }.not_to raise_error
      end

      it 'raise error if width is more than max_width' do
        expect { uploader.check_width }.to raise_error(/Width is too high/)
      end
    end

    context '#check_height' do
      it 'passes validation if height is lower or equal than max_height' do
        uploader.define_singleton_method(:max_height, proc { 558 })
        expect { uploader.check_height }.not_to raise_error
      end

      it 'raise error if height is more than max_height' do
        expect { uploader.check_height }.to raise_error(/Height is too high/)
      end
    end
  end
end
