module UsersHelper
  def success_update
    render :json => {
        :message => 'User has been updated successfully',
        data: {
            :username => @user.username
        }
    }
  end

  class UpdateForm
    include FileHelper::Uploader
    attr_reader :errors, :user, :params, :file

    def initialize(user, params)
      @user = user
      @params = params
      @errors = nil
      @file = ImageUploader.new(@user, 'avatars', @params[:avatar], {max_size: 500})
    end

    def valid?
      unless @params[:avatar].nil?
        return false unless validate_and_prepare_file(@file)
      end

      @user.assign_attributes(@params)
      unless @user.valid?
        @errors = @user.errors.full_messages
        return false
      end
      true
    end

    private
    def validate_and_prepare_file(file)
      if file.valid?
        @params[:avatar] = file.path + '?updated=' + Time.now.to_i.to_s
      else
        @errors = [file.error]
        false
      end
    end
  end


  class Updating

    def initialize(form)
      @form = form
    end

    def update
      @form.user.update(@form.params) && @form.file.save
    end
  end
end
