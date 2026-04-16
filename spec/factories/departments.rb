FactoryBot.define do
  factory :department do
    name { Faker::Commerce.department }
    description { Faker::Lorem.sentence }
  end
end
