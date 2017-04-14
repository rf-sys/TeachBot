class RemoveResourceFromRoles < ActiveRecord::Migration[5.0]
  def up
    remove_column :roles, :resource_type
    remove_column :roles, :resource_id
  end

  def down
    add_reference :roles, :resource, polymorphic: true, index: true
  end
end
