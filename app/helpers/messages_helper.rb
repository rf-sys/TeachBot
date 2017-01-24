module MessagesHelper
  # returns true if current user isn't included into list of users, which didn't read the message
  # @param [Message] message
  # @return boolean
  def is_read?(message, user)
    !message.unread_users.include?(user)
  end

  # add new message to unread messages for all passed users, exclude current
  def broadcast_new_unread_message(users, current_user)
    users = users - [current_user]

    users.each { |user| UnreadMessagesChannel.add_message(user) }
  end
end