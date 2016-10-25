module Uploader

  class AvatarUploader
    def initialize(user, avatar)

      @avatar = avatar
      @user = user
      @dir = Rails.root.join('app', 'assets/images/avatars/' + @user.id.to_s)
    end

    def make_dir
      unless File.exist? @dir
        Dir.mkdir @dir
      end
      self
    end

    def save
      File.open(Rails.root.join('app', 'assets/images/avatars/' + @user.id.to_s, 'avatar.jpg'), 'wb') do |file|
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