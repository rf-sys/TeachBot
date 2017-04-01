module MessagesHelper
  # returns true if current user isn't included into list of users, which didn't read the message
  # @param [Message] message
  # @return boolean
  def read?(message, user)
    !message.unread_users.include?(user)
  end

  # add new message to unread messages for all passed users, exclude current
  def broadcast_new_unread_message(users, current_user)
    users -= [current_user]

    users.each { |user| UnreadMessagesChannel.add_message(user) }
  end

  # get user's unread messages of specific chat
  def chat_unread_messages(user, chat_id)
    user.unread_messages.includes(:user).where(chat_id: chat_id)
  end

  # get chat's messages
  def chat_messages(chat)
    chat.messages.includes(:unread_users).order(created_at: :desc)
  end
end