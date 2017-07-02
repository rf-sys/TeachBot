json.chat do
  json.id @chat.id
  json.initiator_id @chat.initiator_id
  json.recipient_id @chat.recipient_id
  json.last_message do
    json.id @message.id
    json.text @message.text
    json.user do
      json.extract! @message.user, :id, :username, :avatar
    end
    json.read read?(@message, current_user)
  end
  json.users @chat.members, :id, :username, :avatar
end
json.type :new_chat
