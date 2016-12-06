class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.belongs_to :course, index: true
      t.string :title
      t.text :description
      t.timestamps
    end
  end
end
