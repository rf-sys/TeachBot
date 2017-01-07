class ChatControllers::MessagesController < ApplicationController
  include MessagesHelper
  before_action :require_user

  def create

    chat = get_from_cache(Chat, params[:chat_id])

    unless chat.public_chat
      unless current_user_related_to_chat(chat)
        return error_message('Forbidden', 403)
      end
    end

    message = current_user.messages.new(message_params)


    if chat.messages << message
      message.unread_users << [chat.users] unless chat.public_chat
      render :json => {:message => 'Message has been sent'}
      # broadcast message into the chat (message.chat)
      (chat.public_chat) ? message_broadcast(message, 'public_chat_message') : message_broadcast(message)
      # send notification about new message to all users, exclude current
      # ac_notification_send(chat.users, send_json(message))
      # broadcast about new message for all users, exclude current
      ac_unread_message(chat.users)
    else
      error_message(message.errors.full_messages, 422)
    end

  end


  private

  def message_params
    params.require(:message).permit(:text)
  end

  # send notification to all passed users, exclude current
  # @param [User] users
  def ac_notification_send(users, data)
    users = users_exclude_current(users, current_user)

    users.each { |user| NotificationsChannel.broadcast_to(user, {response: data, type: 'notify_new_message'}) }
  end

  # add new message to unread messages for all passed users, exclude current
  def ac_unread_message(users)
    users = users_exclude_current(users, current_user)

    users.each { |user| UnreadMessagesChannel.add_message(user) }
  end

  def equal_recipient?(user)
    current_user == user
  end

  # @param [Chat] chat
  def current_user_related_to_chat(chat)
    chat.users.include?(current_user)
  end
end
