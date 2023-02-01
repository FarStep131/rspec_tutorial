FactoryBot.define do
  factory :tweet do
    # 英数字のランダムな文字列を生成する（100文字）
    content { Faker::Lorem.characters(number: 100) }
  end
end