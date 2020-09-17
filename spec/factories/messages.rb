FactoryBot.define do
  factory :message do
    sequence :body do |n|
      "メッセージ_#{n}"
    end
  end
end
