# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)


pw = 'password'

# ユーザー情報を追加します。
User.create!( name: "Ichi Taro",
              email: 'ichi_taro@example.org',
              password: pw,
              password_confirmation: pw,
              admin: true,
              activated: true,
              activated_at: Time.zone.now
            )

User.create!( name: "Ni Taro",
              email: 'ni_taro@example.org',
              password: pw,
              password_confirmation: pw,
              activated: true,
              activated_at: Time.zone.now
            )
User.create!( name: "San Taro",
              email: 'san_taro@example.org',
              password: pw,
              password_confirmation: pw,
              activated: true,
              activated_at: Time.zone.now
            )

(4..100).each do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@example.org"
  User.create!(name: name, email: email, password: pw, password_confirmation: pw,
  activated: true,
  activated_at: Time.zone.now)
end

users = User.order(:created_at).take(6)
50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
