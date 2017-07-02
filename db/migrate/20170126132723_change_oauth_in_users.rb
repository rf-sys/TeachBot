class ChangeOauthInUsers < ActiveRecord::Migration[5.0]
  def change
    change_table :users do |t|
      t.string :provider
      t.string :uid
      t.remove :facebook_id
    end
  end
end
