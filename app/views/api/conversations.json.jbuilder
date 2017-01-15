json.array! @chats do |chat|
  json.cache!("users/#{current_user.cache_key}/conversations/#{chat.cache_key}") do
    json.extract! chat, :id
    json.users chat.users, :id, :username, :avatar

    if (last_msg = chat.messages.order(created_at: :asc).last)
      json.last_message do
        json.extract! last_msg, :id, :text, :created_at
        json.user last_msg.user, :id, :username, :avatar
        json.read check_if_read(last_msg, current_user)
      end
    end
  end

  json.unread_messages_count current_user.unread_messages.where(:messages => {chat_id: chat.id}).count
end