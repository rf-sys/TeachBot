module FileHelper
  module Uploader

    class ImageUploader

      attr_reader :path
      attr_reader :error

      def initialize(entity, dir, image = nil, options = {})
        @image = image
        @entity = entity
        @path = "/assets/images/#{dir}/#{@entity.id}.jpg"
        @dir = dir
        @options = options
      end

      def save
        if @image.nil?
          return true
        end
        File.open(Rails.root.join('public', 'assets/images/' + @dir, "#{@entity.id}.jpg"), 'wb') do |file|
          file.write(@image.read)
        end
      end

      def valid?
        begin
          check_type
          check_size
          return true
        rescue => error
          @error = error
        end

        false
      end

      protected
      def check_type
        accepted_formats = %w(.png .jpg .jpeg .bmp .gif .svg)
        unless accepted_formats.include? File.extname(@image.original_filename).downcase
          raise 'File has no valid type (image required)'
        end
      end

      def check_size
        size = @options[:max_size] || 500
        unless @image.size <= size.kilobytes
          raise "File is too large (Maximum size: #{size} kb)"
        end
      end
    end

  end
end