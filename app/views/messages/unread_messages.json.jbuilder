json.messages @messages do |message|
  json.extract! message, :id, :text, :created_at
  json.user message.user, :id, :username, :avatar
end