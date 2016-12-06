class CreateCourses < ActiveRecord::Migration[5.0]
  def change
    create_table :courses do |t|
      t.belongs_to :author, index: true
      t.string :title
      t.string :description
      t.boolean :public
      t.timestamps
    end
  end
end
