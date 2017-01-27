module ChatsHelper
  # check if given user is related to given chat
  # @param [Chat] chat
  # @param [User] user
  # @return boolean
  def user_related_to_chat(chat, user)
    return true if chat.public_chat
    chat.users.include?(user)
  end

  def user_is_initiator(user, chat)
    chat.initiator_id == user.id
  end
end