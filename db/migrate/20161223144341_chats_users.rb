class ChatsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :chats_users, id: false do |t|
      t.belongs_to :chat, index: true
      t.belongs_to :user, index: true
    end
  end
end
