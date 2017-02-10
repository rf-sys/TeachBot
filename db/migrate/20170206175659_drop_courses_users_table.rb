class DropCoursesUsersTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :courses_users do |t|
      t.belongs_to :course, index: true
      t.belongs_to :user, index: true
      t.timestamps
    end
  end
end
