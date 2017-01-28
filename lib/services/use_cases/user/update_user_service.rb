# business logic
module Services
  module UseCases
    module User
      module UpdateUserService
        class UpdateUser
          include FileHelper::Uploader

          # init adapters
          # @param [Repositories::UserRepository] user_repository
          # @param [UsersController] listener
          def initialize(user_repository, listener)
            @user_repository = user_repository
            @listener = listener
          end

          # update user's data
          def update(user, params)
            avatar = nil
            if params[:avatar]
              avatar = ImageUploader.new(user, 'avatars', params[:avatar], {max_size: 500})
              return @listener.error_message([avatar.error], 422) unless avatar.valid?
              params[:avatar] = avatar.path + '?updated=' + Time.now.to_i.to_s
            end

            if @user_repository.update(user, params)
              avatar.try(:save)
              @listener.success_update(user)
            else
              @listener.error_message([user.errors.full_messages], 422)
            end
          end
        end
      end
    end
  end
end
