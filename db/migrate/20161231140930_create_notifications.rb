class CreateNotifications < ActiveRecord::Migration[5.0]
  def change
    create_table :notifications do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.string :text
      t.string :link
      t.boolean :readed, default: false
      t.timestamps
    end
  end
end
