class CreateMemberships < ActiveRecord::Migration[5.0]
  def up
    drop_table :chats_users

    create_table :memberships do |t|
      t.references :user, foreign_key: true
      t.references :chat, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :memberships

    create_table :chats_users, id: false do |t|
      t.belongs_to :chat, index: true
      t.belongs_to :user, index: true
    end
  end
end
