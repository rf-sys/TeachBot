class CreateProfiles < ActiveRecord::Migration[5.0]
  def change
    create_table :profiles do |t|
      t.belongs_to :user, index: true
      t.string :facebook
      t.string :twitter
      t.string :website
      t.string :location
      t.string :about

      t.timestamps
    end
  end
end
