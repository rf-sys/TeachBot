# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.message([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.message(name: 'Luke', movie: movies.first)

# create roles
Role.create([{ name: 'user' }, { name: 'teacher' }, { name: 'admin' }])

# create default admin user
user = User.create(username: 'administrator', email: 'admin@mail.ru', password: ENV['ADMIN_ACCOUNT_PASSWORD'], activated: true)

# add roles to admin user
user.add_role(:teacher)
user.add_role(:admin)

# create public chat
Chat.create(initiator: user, recipient: user, public_chat: true)

# create indexes (elasticsearch)
User.reindex
Lesson.reindex
Course.reindex