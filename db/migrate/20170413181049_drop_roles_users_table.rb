class DropRolesUsersTable < ActiveRecord::Migration[5.0]
  def change
    drop_table :roles_users
  end
end
