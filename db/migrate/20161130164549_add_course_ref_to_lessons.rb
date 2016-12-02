class AddCourseRefToLessons < ActiveRecord::Migration[5.0]
  def change
    add_reference :lessons, :course, index: true, foreign_key: true
  end
end
