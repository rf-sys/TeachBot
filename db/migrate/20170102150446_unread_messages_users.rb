class UnreadMessagesUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :unread_messages_users, id: false do |t|
      t.belongs_to :message, index: true
      t.belongs_to :user, index: true
    end
  end
end
