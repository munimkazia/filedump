# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(email: 'admin@admin.com', password: 'adminpass', password_confirmation:'adminpass', admin: 1)
User.create(email: 'user@test.com', password: 'userpass', password_confirmation:'userpass', admin: 0)
User.create(email: 'user2@test.com', password: 'user2pass', password_confirmation:'user2pass', admin: 0)