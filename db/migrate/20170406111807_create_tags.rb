class CreateTags < ActiveRecord::Migration[5.0]
  def up
    remove_column :courses, :tags
    create_table :tags do |t|
      t.string :name
      t.references :taggable, polymorphic: true, index: true
      t.timestamps
    end
  end

  def down
    drop_table :tags
    add_column :courses, :tags, :string, null: true
  end
end
