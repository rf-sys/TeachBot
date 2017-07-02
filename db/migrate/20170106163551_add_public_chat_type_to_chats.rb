class AddPublicChatTypeToChats < ActiveRecord::Migration[5.0]
  def change
    add_column :chats, :public_chat, :boolean, default: false
  end
end
