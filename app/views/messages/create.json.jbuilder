json.chat do
  json.id @chat.id
  json.initiator @chat.initiator_id
  json.recipient @chat.recipient_id
  json.last_message do
    json.id @message.id
    json.text @message.text
    json.user do
      json.extract! @message.user, :id, :username, :avatar
    end
    json.read check_if_read(@message)
  end
  json.users @chat.users, :id, :username, :avatar
end
json.type :new_chat