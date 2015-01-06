# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
User.create(username: 'admin', password: 'admin', admin: 1)
User.create(username: 'user', password: 'user', admin: 0)
User.create(username: 'user2', password: 'user2', admin: 0)