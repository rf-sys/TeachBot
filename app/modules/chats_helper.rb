module ChatsHelper
  # check if given user is related to given chat
  # @param [Chat] chat
  # @param [User] user
  # @return boolean
  def user_related_to_chat(chat, user)
    chat.users.include?(user)
  end
end