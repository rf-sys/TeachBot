# business logic
module Services
  module UseCases
    module User
      module UpdateUserService
        class UpdateUser
          require_dependency 'uploaders/avatar_uploader'

          # init adapters
          # @param [Repositories::UserRepository] user_repository
          # @param [UsersController] listener
          def initialize(user_repository, listener)
            @user_repository = user_repository
            @listener = listener
          end

          # update user's data
          def update(user, params)
            uploader = nil
            if params[:avatar]
              uploader = AvatarUploader.new(params[:avatar], user.id)
              return @listener.error_message([uploader.error], 422) unless uploader.has_valid_file?
              params[:avatar] = uploader.url
            end

            if @user_repository.update(user, params)
              uploader.try(:store)
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
