class MessagesController < ApplicationController
  before_action :require_user
  include MessagesHelper
  include Services::UseCases::Message::CreateMessageService

  # handle modal window of sending new message to user
  def create
    # I'm not sure about this approach to organize code with hexagonal.
    # Hexagonal fit very well with one single model,
    # but when more than one, classic examples actually don't work very well
    create_message_service = CreateMessage.new(self)
    create_message_service.assign_recipient(params[:user_id])
    @chat = create_message_service.set_chat_between_users(current_user)
    @message = create_message_service.assign_message(current_user, message_params)
    create_message_service.create
  end

  def mark_as_read
    message = get_from_cache(Message, params[:id])
    chat_id = message.chat_id
    message_id = message.id
    if current_user.unread_messages.delete(message)
      UnreadMessagesChannel.remove_message(current_user, chat_id, message_id)
      render :json => {status: 'done'}, status: 200
    else
      render :json => 'Something went wrong', status: 422
    end
  end

  # POST - mark all unread messages as read for current_user
  # @return [Object]
  def mark_all_as_read
    messages = current_user.unread_messages.where(chat_id: params[:chat_id])
    if current_user.unread_messages.delete(messages)
      render :json => {status: 'done'}, status: 200
    else
      render :json => 'Something went wrong', status: 422
    end
  end

  # POST - return all user's unread messages
  # @return [Array]
  def unread_messages
    @messages = current_user.unread_messages.includes(:user).where(:messages => {chat_id: params[:chat_id]})
  end

  # POST - return user's unread messages count
  # @return [Object]
  def unread_messages_count
    count = current_user.unread_messages.count
    render :json => {count: count}
  end

  # sends notification about new chat to recipient
  # @param [Chat] chat
  def send_new_chat_notification(chat)
    recipient = chat.recipient
    notification = Notification.generate(
        'New chat',
        'New chat from ' + current_user.username,
        '/chats#dialog=' + chat.id.to_s
    )
    recipient.attach_notification(notification)
    NotificationsChannel.broadcast_notification_to(recipient, notification)
  end

  # save message and send message through Cable
  # @param [Chat] chat
  # @param [Message] message
  def send_message(chat, message)
    ChatChannel.send_message(chat.id, message)
    broadcast_new_unread_message(chat.users, current_user)
  end

  private

  def message_params
    params.require(:message).permit(:text)
  end

end
