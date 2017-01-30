# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel
  include CustomHelper::Cache, ChatsHelper

  def subscribed
    @public_chat = Chat.public_chat

    stream_from 'Chat:' + @public_chat.id.to_s
    stream_from "user_#{current_user.id}_new_chat"

    current_user.chats.uniq.each do |chat|
      stream_from "Chat:#{chat.id}"
    end
  end

  # user has left the chat
  def unsubscribed
    $redis_connection.srem('participants', current_user.to_json)
    receive_members
  end

  # user has been joined to the chat
  def appear
    $redis_connection.sadd('participants', current_user.to_json)
    receive_members
  end

  # user has left the chat
  def leave
    $redis_connection.srem('participants', current_user.to_json)
    receive_members
  end

  def new_chat(chat)
    stream_from "Chat:#{chat['chat']['id']}"

    recipient = User.find(chat['chat']['recipient_id'])

    unless current_user.id == recipient.id
      ActionCable.server.broadcast "user_#{recipient.id}_new_chat", chat: chat['chat'], type: 'new_chat'
    end
  end

  def subscribe_to_chat(data)
    if current_user
      chat = Chat.find(data['chat_id'])
      if chat && user_related_to_chat(chat, current_user)
        stream_from "Chat:#{data['chat_id']}"
      end
    end
  end

  class << self
    def send_message(chat_id, message, type = 'message')
      ActionCable.server.broadcast "Chat:#{chat_id}", response: json_message(message), type: type
    end

    def send_notification_to_chat(chat_id, text, type = 'chat_notification')
      ActionCable.server.broadcast "Chat:#{chat_id}", text: text,
                                   chat_id: chat_id, type: type
    end
  end

  private

  # use in public chat to receive active members
  def receive_members
    members = $redis_connection.smembers('participants')
    members.map! { |item| JSON.parse(item) }

    ActionCable.server.broadcast "Chat:#{@public_chat.id}", members: members, type: 'members'
  end

  class << self
    # json response format for new messages
    # @param [Message] message
    def json_message(message)
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
  end
end
