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

    @message = init_message(message_params, @chat)

    unless @message.valid?
      return error_message(@message.errors.full_messages, 422)
    end

    if @chat.new_record?
      @chat.create_and_add_participants
      save_and_send_with_cable(@chat, @message) do
        send_new_chat_notification(@chat)
        broadcast_new_unread_message(@chat.users, current_user)
      end
    else
      save_and_send_with_cable(@chat, @message) do
        render json: {response: @message, type: :new_message}
      end
    end

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

  # generate message
  def init_message(params, chat)
    message = Message.new(params)
    message.user = current_user
    message.chat = chat
    message
  end

  # save message and send message through Cable
  # @param [Chat] chat
  # @param [Message] message
  def save_and_send_with_cable(chat, message)
    chat.messages << message
    message.unread_users << [chat.users]
    message_broadcast(message)
    if block_given?
      yield
    end
  end

end
