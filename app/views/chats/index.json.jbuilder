json.array! @chats do |chat|
  json.cache!("users/#{current_user.cache_key}/conversations/#{chat.cache_key}") do
    json.extract! chat, :id, :initiator_id
    json.users chat.users.uniq, :id, :username, :avatar, :slug

    if (last_msg = chat.messages.order(created_at: :asc).last)
      json.last_message do
        json.extract! last_msg, :id, :text, :created_at
        json.user last_msg.user, :id, :username, :avatar
        json.read read?(last_msg, current_user)
      end
    end
  end

  json.unread_messages_count current_user.unread_messages.where(:messages => {chat_id: chat.id}).count
end
