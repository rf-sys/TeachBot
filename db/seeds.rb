# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.message([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.message(name: 'Luke', movie: movies.first)

Role.create([{ name: 'user' }, { name: 'teacher' }, { name: 'admin' }])

user = User.create(username: 'admin', email: 'admin@mail.ru', password: ENV['ADMIN_ACCOUNT_PASSWORD'], activated: true)
user.add_role(:teacher)
user.add_role(:admin)

Chat.create(title: 'Public Chat')
