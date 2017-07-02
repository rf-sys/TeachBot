class AddTagsCountToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :tags_count, :integer, default: 0
  end
end
