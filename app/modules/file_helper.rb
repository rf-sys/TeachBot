module FileHelper
  module Uploader

    class AvatarUploader

      attr_reader :path
      attr_reader :error

      def initialize(user, avatar = nil)
        @avatar = avatar
        @user = user
        @path = "/assets/images/avatars/#{@user.id}.jpg"
      end

      def save
        if @avatar.nil?
          return true
        end
        File.open(Rails.root.join('public', 'assets/images/avatars', "#{@user.id}.jpg"), 'wb') do |file|
          file.write(@avatar.read)
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
        unless accepted_formats.include? File.extname(@avatar.original_filename).downcase
          raise 'File has no valid type (image required)'
        end
      end

      def check_size
        unless @avatar.size < 500.kilobytes
          raise 'File is too large (Maximum size: 500 kb)'
        end
      end
    end

  end
end