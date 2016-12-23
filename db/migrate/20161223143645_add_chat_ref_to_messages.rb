class AddChatRefToMessages < ActiveRecord::Migration[5.0]
  def change
    add_reference :messages, :chat, foreign_key: true
  end
end
