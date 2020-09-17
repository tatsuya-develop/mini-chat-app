# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

chat_groups = [];

3.times do |n|
  chat_group = ChatGroup.create!(name: "テストチャットグループ#{n +  1}")
  chat_groups.push(chat_group)
end
  
chat_groups.each do |chat_group|
  3.times { |i| chat_group.messages.create!(body: "テストメッセージ#{i + 1}") }
end
