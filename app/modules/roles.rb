module Roles
  extend ActiveSupport::Concern

  included do
    has_many :user_roles, dependent: :destroy
    has_many :roles, through: :user_roles

    after_create :assign_default_role
  end

  def role?(role)
    roles.pluck(:name).include?(role.to_s)
  end

  def add_role(role)
    role = Role.find_or_create_by(name: role.to_s)
    roles.destroy(role)
    roles << role
  end

  def assign_default_role
    add_role(:user) if roles.blank?
  end
end
