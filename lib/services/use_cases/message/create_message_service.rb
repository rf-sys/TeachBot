# business logic
module Services
  module UseCases
    module Message
      module CreateMessageService
        # @param [Repositories::MessageRepository] message_repository
        # @param [MessagesController] listener
        def initialize(message_repository, listener)
          @message_repository = message_repository
          @listener = listener
        end

        def create(author, chat, params)
          message = @message_repository.initialize_new_message(author, chat, params)

          unless @message_repository.valid?(message)
            return @listener.error_message([message.errors.full_messages], 422)
          end

          if chat.new_record?
            @message_repository
          else

          end

        end
      end
    end
  end
end
