class RemoveTitleFromChats < ActiveRecord::Migration[5.0]
  def change
    change_table :chats do |t|
      t.remove :title
    end
  end
end
