module MessagesHelper
  def users_exclude_current(users, current_user)
    users - [current_user]
  end

  def message_broadcast(message, type = 'message')
    ActionCable.server.broadcast "Chat:#{message.chat_id}", response: send_json(message), type: type
  end

  # json response format for new messages
  # @param [Message] message
  def send_json(message)
    {
        message: {
            id: message.id,
            text: message.text,
            chat_id: message.chat_id,
            created_at: message.created_at,
            user: message.user.attributes.slice('id', 'username', 'avatar'),
            read: false
        }
    }
  end

  # returns true if current user isn't included into list of users, which didn't read the message
  # @param [Message] message
  # @return boolean
  def check_if_read(message)
    !message.unread_users.include?(current_user)
  end

  def user_related_to_chat(chat, user)
    chat.users.include?(user)
  end

  # add new message to unread messages for all passed users, exclude current
  def broadcast_new_unread_message(users, current_user)
    users = users_exclude_current(users, current_user)

    users.each { |user| UnreadMessagesChannel.add_message(user) }
  end
end

module MessageStrategy
  module MessageCreateStrategy
    class MessageCreateStrategyClass
      include MessagesHelper

      def initialize(chat, message, current_user)
        @chat = chat
        @message = message
        @current_user = current_user
      end

      def save(strategy)
        strategy.save(@chat, @message, @current_user)
      end

      def have_access?
        unless @chat.public_chat
          unless user_related_to_chat(@chat, @current_user)
            return false
          end
          return true
        end
        true
      end
    end

    class ChatMessage
      attr_reader :errors
      def initialize
        @errors = []
      end
    end


    class PublicChatMessage < ChatMessage
      include MessagesHelper

      def save(chat, message, current_user = nil)
        if chat.messages << message
          after_save_events(message)
          true
        else
          @errors = message.errors.full_messages
          false
        end
      end

      def after_save_events(message)
        message_broadcast(message, 'public_chat_message')
      end

    end


    class PrivateChatMessage < ChatMessage
      include MessagesHelper

      def save(chat, message, current_user)
        if chat.messages << message
          after_save_events(chat, message, current_user)
          true
        else
          @errors = message.errors.full_messages
          false
        end
      end

      def after_save_events(chat, message, current_user)
        message.unread_users << [chat.users]
        message_broadcast(message)
        broadcast_new_unread_message(chat.users, current_user)
      end
    end

  end
end