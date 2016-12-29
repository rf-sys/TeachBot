class RenameChatsTextColumnToTitle < ActiveRecord::Migration[5.0]
  def change
    change_table :chats do |t|
      t.rename :text, :title
    end
  end
end
