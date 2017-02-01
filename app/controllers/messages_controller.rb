class MessagesController < ApplicationController
  before_action :require_user
  include MessagesHelper

  # calls when we use modal window to send message to user, with which we haven't got a chat yet.
  # Logic:
  # 1. try to find user, otherwise - return json with error
  # 2. try to find or init a new chat between found and current users if this chat already exists or not respectively
  # 3. try to validate (saved in further) message; return json error if no valid
  # 4. if found chat is new - save this chat and add participants, save message and send notifications
  # 5. if found chat already exists - attach message to this chat and send notification about new message with Cable
  def create
    unless (user = User.find_by_id(params[:user_id]))
      return error_message(['Recipient not found'], 404)
    end

    @chat = Chat.find_or_initialize_between(current_user, user)

    @message = Message.new_message(message_params, {user: current_user, chat: @chat})

    return error_message(@message.errors.full_messages, 422) unless @message.valid?

    if @chat.new_record?
      @chat.save_and_add_participants
      send_new_chat_notification(@chat)
      save_and_send_message(@chat, @message)
    else
      save_and_send_message(@chat, @message)
      render json: {response: @message, type: :new_message}
    end

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

  private

  def message_params
    params.require(:message).permit(:text)
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
  def save_and_send_message(chat, message)
    message.save_with_unread_users(chat)
    ChatChannel.send_message(chat.id, message)
    broadcast_new_unread_message(chat.users, current_user)
  end

end
