FactoryBot.define do
  factory :tweet do
    content { Faker::Lorem.characters(number: 100) }
  end
end
