module MessageStrategies
  module MessageCreateStrategy

    # MessageCreateStrategy defines "save" logic for messages depends on public or private chat

    class MessageCreate
      include MessagesHelper
      # @param [Chat] chat
      # @param [Message] message
      def initialize(chat, message, user)
        @chat = chat
        @message = message
        @user = user
      end

      # @return boolean
      def public_chat?
        @chat.public_chat
      end

      def have_access_to_chat?
        unless @chat.public_chat
          unless user_related_to_chat(@chat, @user)
            return false
          end
          return true
        end
        true
      end

      # @param [Object] maker
      def save_as(maker)
        maker.save_message(@chat, @message, @user)
      end
    end


    module MessageMakers
      class Maker
        include MessagesHelper
        attr_reader :errors
        @errors = []

        # @param [Chat] chat
        # @param [Message] message
        def saved_message?(chat, message)
          unless chat.messages << message
            @errors = message.errors.full_messages
            return false
          end
          true
        end
      end

      class PublicMessageMaker < Maker
        def save_message(chat, message, user)
          unless saved_message?(chat, message)
            return false
          end
          after_save_events(message)
          true
        end

        def after_save_events(message)
          message_broadcast(message, 'public_chat_message')
        end
      end

      class PrivateMessageMaker < Maker
        def save_message(chat, message, user)
          unless saved_message?(chat, message)
            return false
          end
          after_save_events(chat, message, user)
          true
        end

        # @param [Chat] chat
        # @param [Message] message
        # @param [User] user
        def after_save_events(chat, message, user)
          <<~EXPLANATION
            We dont need to update all chats, given users related to. This causes touching all chat's users and hence
            we touch all chats they belongs to and clear a lot of extra cache, though we have already updated that chat
            after create a message and further touching is excessive load.
          EXPLANATION
          ActiveRecord::Base.no_touching { message.unread_users << [chat.users] }
          message_broadcast(message)
          broadcast_new_unread_message(chat.users, user)
        end
      end
    end
  end
end