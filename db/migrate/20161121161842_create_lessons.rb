class CreateLessons < ActiveRecord::Migration[5.0]
  def change
    create_table :lessons do |t|
      t.belongs_to :user, index: true
      t.string :title
      t.text :text
      t.timestamps
    end
  end

end
