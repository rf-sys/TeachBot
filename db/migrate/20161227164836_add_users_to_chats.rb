class AddUsersToChats < ActiveRecord::Migration[5.0]
  def change
    add_column :chats, :initiator_id, :integer, index: true
    add_column :chats, :recipient_id, :integer, index: true
  end
end
