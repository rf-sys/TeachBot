class ChatControllers::MessagesController < ApplicationController
  include ChatsHelper
  include MessagesHelper

  before_action :authenticate_user!
  before_action :set_chat
  before_action :check_relation_to_chat

  # get messages, related to specific Chat with pagination
  # @return [Object]
  def index
    page = params[:page]
    @messages = chat_messages(@chat).paginate(page, 2)
  end

  def create
    message = current_user.messages.new_message(message_params, chat: @chat)

    if message.save
      ActiveRecord::Base.no_touching { message.unread_users << [@chat.members] }
      ChatChannel.send_message(@chat.id, message)
      broadcast_new_unread_message(@chat.members, current_user)
    else
      error_message(message.errors.full_messages, 422)
    end
  end

  private

  def set_chat
    @chat = fetch_cache(Chat, params[:chat_id])
  end

  def check_relation_to_chat
    unless user_related_to_chat(@chat, current_user)
      error_message(['Forbidden'], 403)
    end
  end

  def message_params
    params.require(:message).permit(:text)
  end
end
