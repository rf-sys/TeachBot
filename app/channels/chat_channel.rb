# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatChannel < ApplicationCable::Channel
  include CustomHelper::Cache, ChatsHelper

  def subscribed
    stream_from "user_#{current_user.id}_chats"
    current_user.chats.uniq.each do |chat|
      stream_from "Chat:#{chat.id}"
    end
  end

  # calls from the client to add a new chat block in chats page
  def send_new_chat(data)
    stream_from "Chat:#{data['chat']['id']}"
    recipient = User.find(data['chat']['recipient_id'])
    unless current_user.id == recipient.id
      ActionCable.server.broadcast "user_#{recipient.id}_chats", chat: data['chat'], type: 'new_chat'
    end
  end

  # add streaming from chat to current_user if user is related to this chat
  # check is necessary because it is called from the client
  def subscribe_to_chat(data)
    if current_user
      chat = fetch_cache(Chat, data['chat_id'])
      if chat && user_related_to_chat(chat, current_user)
        stream_from "Chat:#{data['chat_id']}"
      end
    end
  end

  class << self
    # send events (like '%username% left the chat') into the chat
    def send_notification_to_chat(chat_id, text, type = 'chat_notification')
      ActionCable.server.broadcast "Chat:#{chat_id}", text: text,
                                   chat_id: chat_id, type: type
    end

    # send message into the chat
    def send_message(chat_id, message)
      ActionCable.server.broadcast "Chat:#{chat_id}", response: chat_message(message), type: 'message'
    end
  end

  private

  # template for private messages
  def self.chat_message(message)
    {
        message: {
            id: message.id,
            text: message.text,
            chat_id: message.chat_id,
            created_at: message.created_at,
            user: message.user.attributes.slice('id', 'username', 'avatar', 'slug'),
            read: false
        }
    }
  end
end
