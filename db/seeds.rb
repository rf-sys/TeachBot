# create roles
roles = Role.all
Role.create(name: 'user') unless roles.any? { |role| role.name == 'user' }
Role.create(name: 'teacher') unless roles.any? { |role| role.name == 'teacher' }
Role.create(name: 'admin') unless roles.any? { |role| role.name == 'admin' }

# create default admin user
admin = User.joins(:roles).where('roles.name' => 'admin').first

if admin.blank?
  admin = User.create(username: 'administrator', email: 'admin@mail.ru', password: ENV['ADMIN_ACCOUNT_PASSWORD'], activated: true)
  admin.add_role(:teacher)
  admin.add_role(:admin)
end

# create public chat
unless Chat.where(public_chat: true).any?
  Chat.create(initiator: admin, recipient: admin, public_chat: true)
end

# create indexes (elasticsearch)
User.reindex
Lesson.reindex
Course.reindex