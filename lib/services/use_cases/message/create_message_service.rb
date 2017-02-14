# business logic
module Services
  module UseCases
    module Message
      module CreateMessageService
        class CreateMessage
          # @param [MessagesController] listener
          def initialize(listener)
            @listener ||= listener

            @user_repository = Repositories::UserRepository
            @chat_repository = Repositories::ChatRepository
            @message_repository = Repositories::MessageRepository
          end

          # @param [Integer] user_id
          def assign_recipient(user_id)
            @recipient = @user_repository.find_by_id(user_id)
          end

          # @param [User] auth_user
          def set_chat_between_users(auth_user)
            @chat = @chat_repository.set_between_users(auth_user, @recipient)
          end

          # @param [User] auth_user
          # @param [Hash] message_params
          def assign_message(auth_user, message_params)
            @message = @message_repository.initialize_new_message(auth_user, @chat, message_params)
          end

          # @return json
          def create
            unless @recipient
              return @listener.error_message(['Recipient not found'], 404)
            end

            unless @message.valid?
              return @listener.error_message(@message.errors.full_messages, 422)
            end

            if @chat.new_record?
              @chat_repository.save_with_participants(@chat)
              @message_repository.save_with_unread_users(@message, @chat)
              @listener.send_new_chat_notification(@chat)
              @listener.send_message(@chat, @message)
            else
              @message_repository.save_with_unread_users(@message, @chat)
              @listener.send_message(@chat, @message)
              @listener.render json: {response: @message, type: :new_message}
            end
          end
        end
      end
    end
  end
end
