json.array! @chats do |chat|
  json.extract! chat, :id
  json.users chat.users, :id, :username, :avatar

  if (last_msg = chat.messages.last)
  json.last_message do
    json.extract! last_msg, :id, :text, :created_at
    json.user last_msg.user, :id, :username, :avatar
  end
  end

end