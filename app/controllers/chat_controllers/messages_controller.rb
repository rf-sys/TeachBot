class ChatControllers::MessagesController < ApplicationController
  include MessagesHelper, ChatsHelper

  before_action :require_user

  # get messages, related to specific Chat with pagination
  # @return [Object]
  def index
    chat = get_from_cache(Chat, params[:chat_id])

    unless user_related_to_chat(chat, current_user)
      return error_message(['Forbidden'], 403)
    end

    @messages = chat.messages.includes(:unread_users).reverse_order.page(params[:page]).per(2)
  end

  def create
    chat = get_from_cache(Chat, params[:chat_id])

    unless user_related_to_chat(chat, current_user)
      return error_message(['Forbidden'], 403)
    end

    message = current_user.messages.new_message(message_params, chat: chat)

    if message.save
      ActiveRecord::Base.no_touching { message.unread_users << [chat.users] }
      ChatChannel.send_message(chat.id, message)
      broadcast_new_unread_message(chat.users, current_user)
    else
      error_message(message.errors.full_messages, 422)
    end
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end

  def save_message(strategy, maker)
    unless strategy.save_as(maker)
      return error_message(maker.errors, 422)
    end
    if block_given?
      yield
    end
  end
end
