# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

3.times do |n|
  ChatGroup.create!(
    name: "テストチャットグループ#{n +  1}"
  )
  chat_groups = ChatGroup.all
  
  for chat_group in chat_groups do
    3.times do |i|
      Message.create!(
        chat_group_id: chat_group.id,
        body: "テストメッセージ#{i + 1}"
      )
    end
  end
end
