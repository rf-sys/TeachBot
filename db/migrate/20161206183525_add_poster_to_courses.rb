class AddPosterToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :poster, :string, null: true
  end
end
