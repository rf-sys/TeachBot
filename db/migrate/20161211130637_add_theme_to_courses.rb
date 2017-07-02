class AddThemeToCourses < ActiveRecord::Migration[5.0]
  def change
    add_column :courses, :theme, :string, default: '#0275d8'
  end
end
