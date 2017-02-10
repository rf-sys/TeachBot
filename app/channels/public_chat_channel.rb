class PublicChatChannel < ApplicationCable::Channel
  PUBLIC_CHAT_CHANNEL ||= 'public_chat'

  def subscribed
    stream_from PUBLIC_CHAT_CHANNEL
  end

  def unsubscribed
    $redis_connection.srem('participants', current_user.to_json)
    send_members_to_chat
  end

  # user has been joined to the chat
  def appear
    current_user.reload
    $redis_connection.sadd('participants', current_user.to_json)
    send_members_to_chat
  end

  # user has left the chat
  def leave
    $redis_connection.srem('participants', current_user.to_json)
    send_members_to_chat
  end

  class << self
    # send message to the public chat
    # @param [Message] message
    def send_message(message)
      ActionCable.server.broadcast PUBLIC_CHAT_CHANNEL, response: public_chat_message(message), type: 'message'
    end
  end

  private

  # send participants list of the public chat to the client
  def send_members_to_chat
    members = $redis_connection.smembers('participants')
    members.map! { |item| JSON.parse(item) }

    ActionCable.server.broadcast PUBLIC_CHAT_CHANNEL, members: members, type: 'members'
  end

  class << self
    # public chat message template
    # @param [Message] message
    def public_chat_message(message)
      {
          message: {
              id: message.id,
              text: message.text,
              created_at: message.created_at,
              user: message.user.attributes.slice('id', 'username', 'avatar', 'slug')
          }
      }
    end
  end
end
