FactoryBot.define do
  factory :job_title do
    name { Faker::Job.title }
    level { JobTitle::LEVELS.sample }
  end
end
