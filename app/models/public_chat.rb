class PublicChat < ApplicationRecord
  self.table_name = 'chats'
  default_scope { where(public_chat: true) }
end
