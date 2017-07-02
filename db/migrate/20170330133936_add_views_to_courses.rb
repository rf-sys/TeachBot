class AddViewsToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :views, :integer, default: 0
  end
end
