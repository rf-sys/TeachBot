module User
  class UpdateForm
    attr_reader :error

    def initialize(user, params)
      @user = user
      @params = params
      @error = nil
    end

    def update
      file = FileHelper::Uploader::ImageUploader.new(@user, 'avatars', @params[:user][:avatar], {max_size: 500})
      unless @params[:user][:avatar]
        update_file(file)
      end
      if @user.update(params) && file.save
        true
      else
        @error = @user.errors.full_messages
        false
      end
    end

    private

    def update_file(file)
      if file.valid?
        @params[:user][:avatar] = file.path + '?updated=' + Time.now.to_i.to_s
      else
        @error = file.error
      end
    end
  end
end