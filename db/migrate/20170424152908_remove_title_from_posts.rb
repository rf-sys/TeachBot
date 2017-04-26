class RemoveTitleFromPosts < ActiveRecord::Migration[5.0]
  def up
    remove_column :posts, :title
  end

  def down
    add_column :posts, :title, :string
  end
end
