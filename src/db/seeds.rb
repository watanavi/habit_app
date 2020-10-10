# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.locale = :ja
srand(0)

users_json = []
groups_json = []
File.open("db/fixtures/users.json") do |j|
  users_json = JSON.load(j)
end
File.open("db/fixtures/groups.json") do |j|
  groups_json = JSON.load(j)
end

User.create!(name: "ゲストユーザ",
             email: "guest@example.com",
             introduction: "一時利用のためのゲストユーザです。よろしくお願いします。",
             password: "password",
             password_confirmation: "password")

(users_json.length).times do |n|
  user = User.create!(name: Faker::Name.name,
                     email: "test#{n + 2}@example.com",
                     introduction: users_json[n]["introduction"],
                     password: "password",
                     password_confirmation: "password")
  if rand(3) != 3
    user.image.attach(io: File.open("db/fixtures/images/image (#{rand(200)}).png"), filename: "image (#{rand(200)}).png")
  end
  user.save
end

2.times do |n|
  user = User.find(1)
  group = user.groups.build(name: "テストグループ #{n + 1}",
                            habit: "毎日habit appを起動しよう！",
                            overview: "ゲストユーザが作成したテストグループです。毎日habitappを起動して習慣づけを頑張りましょう！")
  if rand(3) != 3
    group.image.attach(io: File.open("db/fixtures/images/image (#{rand(200)}).png"), filename: "image (#{rand(200)}).png")
  end
  group.save
  user.belong(group)
end

(groups_json.length).times do |n|
  user = User.find(rand(1..User.count))
  group = user.groups.build(name: groups_json[n]["name"],
                            habit: groups_json[n]["habit"],
                            overview: groups_json[n]["overview"])
  if rand(3) != 3
    group.image.attach(io: File.open("db/fixtures/images/image (#{rand(200)}).png"), filename: "image (#{rand(200)}).png")
  end
  group.save
  user.belong(group)
end

User.count.times do |n|
  user = User.find(n + 1)
  3.times do |m|
    group = Group.find(rand(1..Group.count))
    user.belong(group) until user.belonging?(group)
  end
end
