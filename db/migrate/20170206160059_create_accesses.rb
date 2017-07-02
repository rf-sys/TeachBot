class CreateAccesses < ActiveRecord::Migration[5.0]
  def change
    create_table :accesses do |t|
      t.references :user, foreign_key: true
      t.references :accessable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
