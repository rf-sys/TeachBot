class ChangeDefaultUserAvatarValue < ActiveRecord::Migration[5.0]
  def change
    change_column_default :users, :avatar, from: nil, to: '/assets/images/default_avatar.jpeg'
  end
end
