class AddTagsToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :tags, :string, null: true
  end
end
