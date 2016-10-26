module Uploader

  class AvatarUploader
    def initialize(user, avatar)

      @avatar = avatar
      @user = user

    end

    def save
      File.open(Rails.root.join('public', 'assets/images/avatars', "#{@user.id}.jpg"), 'wb') do |file|
        file.write(@avatar.read)
      end

      true
    end

    def check_type
      accepted_formats = %w(.png .jpg .jpeg .bmp .gif .svg)

      puts @avatar.content_type

      if accepted_formats.include? File.extname(@avatar.original_filename).downcase
        return true
      end

      false
    end

    def check_size
      if @avatar.size/1024 > 500
        return false
      end

      true
    end
  end

end