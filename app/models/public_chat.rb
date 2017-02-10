class PublicChat < ApplicationRecord
  self.table_name = 'chats'
  has_many :messages, foreign_key: :chat_id
  default_scope { where(public_chat: true) }
end
