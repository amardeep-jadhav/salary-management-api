FactoryBot.define do
  factory :employee do
    full_name { Faker::Name.name }
    email { Faker::Internet.unique.email }
    phone { Faker::PhoneNumber.phone_number }
    gender { %w[Male Female Non-binary].sample }
    country { Faker::Address.country_code }
    city { Faker::Address.city }
    department
    job_title
    employment_type { Employee::EMPLOYMENT_TYPES.sample }
    salary { Faker::Number.decimal(l_digits: 5, r_digits: 2) }
    currency { 'INR' }
    hired_on { Faker::Date.backward(days: 1000) }
    date_of_birth { Faker::Date.birthday(min_age: 22, max_age: 60) }
    active { true }
  end
end
