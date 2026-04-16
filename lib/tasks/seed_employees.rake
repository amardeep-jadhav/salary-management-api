namespace :db do
  desc "Seed 10,000 employees with bulk insert — safe to run repeatedly"
  task seed_employees: :environment do
    require "benchmark"

    puts "Starting seed..."

    first_names = File.readlines(Rails.root.join("db/data/first_names.txt"), chomp: true).reject(&:blank?)

    last_names = File.readlines(Rails.root.join("db/data/last_names.txt"), chomp: true).reject(&:blank?)

    COUNTRIES = %w[
      US GB IN DE FR CA AU SG JP BR ZA NG AE NL SE NO DK FI
    ].freeze

    CITIES = {
      "US" => %w[New\ York Los\ Angeles Chicago Houston Phoenix],
      "GB" => %w[London Manchester Birmingham Leeds Bristol],
      "IN" => %w[Mumbai Delhi Bangalore Hyderabad Chennai],
      "DE" => %w[Berlin Munich Hamburg Frankfurt Cologne],
      "FR" => %w[Paris Lyon Marseille Toulouse Nice],
      "CA" => %w[Toronto Vancouver Montreal Calgary Ottawa],
      "AU" => %w[Sydney Melbourne Brisbane Perth Adelaide],
      "SG" => %w[Singapore],
      "JP" => %w[Tokyo Osaka Yokohama Nagoya Sapporo],
      "BR" => %w[Sao\ Paulo Rio\ de\ Janeiro Brasilia Salvador],
      "ZA" => %w[Johannesburg Cape\ Town Durban Pretoria],
      "NG" => %w[Lagos Abuja Kano Ibadan],
      "AE" => %w[Dubai Abu\ Dhabi Sharjah],
      "NL" => %w[Amsterdam Rotterdam The\ Hague Utrecht],
      "SE" => %w[Stockholm Gothenburg Malmo],
      "NO" => %w[Oslo Bergen Trondheim],
      "DK" => %w[Copenhagen Aarhus Odense],
      "FI" => %w[Helsinki Tampere Turku]
    }.freeze

    CURRENCIES = {
      "US" => "USD", "GB" => "GBP", "IN" => "INR",
      "DE" => "EUR", "FR" => "EUR", "CA" => "CAD",
      "AU" => "AUD", "SG" => "SGD", "JP" => "JPY",
      "BR" => "BRL", "ZA" => "ZAR", "NG" => "NGN",
      "AE" => "AED", "NL" => "EUR", "SE" => "SEK",
      "NO" => "NOK", "DK" => "DKK", "FI" => "EUR"
    }.freeze

    SALARY_RANGES = {
      "Junior"    => (30_000..60_000),
      "Mid"       => (60_000..90_000),
      "Senior"    => (90_000..130_000),
      "Staff"     => (130_000..170_000),
      "Principal" => (170_000..220_000),
      "Executive" => (200_000..400_000)
    }.freeze

    puts "Ensuring departments and job titles exist..."

    department_names = %w[
      Engineering Product Design Marketing Sales
      Finance HR Operations Legal Customer\ Success
    ]

    department_names.each do |name|
      Department.find_or_create_by!(name: name)
    end

    job_title_data = [
      { name: "Software Engineer",       level: "Mid" },
      { name: "Senior Software Engineer", level: "Senior" },
      { name: "Staff Engineer",           level: "Staff" },
      { name: "Principal Engineer",       level: "Principal" },
      { name: "Junior Developer",         level: "Junior" },
      { name: "Product Manager",          level: "Mid" },
      { name: "Senior Product Manager",   level: "Senior" },
      { name: "Product Designer",         level: "Mid" },
      { name: "UX Researcher",            level: "Junior" },
      { name: "Data Analyst",             level: "Mid" },
      { name: "Data Scientist",           level: "Senior" },
      { name: "DevOps Engineer",          level: "Mid" },
      { name: "Engineering Manager",      level: "Staff" },
      { name: "VP of Engineering",        level: "Executive" },
      { name: "CTO",                      level: "Executive" },
      { name: "HR Manager",              level: "Mid" },
      { name: "Finance Manager",          level: "Mid" },
      { name: "Marketing Manager",        level: "Mid" },
      { name: "Sales Manager",            level: "Senior" },
      { name: "Customer Success Manager", level: "Mid" }
    ]

    job_title_data.each do |jt|
      JobTitle.find_or_create_by!(name: jt[:name]) do |j|
        j.level = jt[:level]
      end
    end

    department_ids = Department.pluck(:id)
    job_titles     = JobTitle.pluck(:id, :level)

    puts "Building 10,000 employee records..."

    name_combinations = first_names.product(last_names).shuffle
    employees_data    = []

    10_000.times do |i|
      first, last = name_combinations[i % name_combinations.length]
      country     = COUNTRIES.sample
      job_id, level = job_titles.sample
      salary_range  = SALARY_RANGES[level] || (40_000..80_000)

      employees_data << {
        full_name:       "#{first} #{last}",
        email:           "#{first.downcase}.#{last.downcase}.#{i}@example.com",
        phone:           "+1#{rand(1_000_000_000..9_999_999_999)}",
        gender:          %w[Male Female Non-binary].sample,
        country:         country,
        city:            (CITIES[country] || [ "Unknown" ]).sample,
        department_id:   department_ids.sample,
        job_title_id:    job_id,
        employment_type: %w[full_time part_time contract].sample,
        salary:          rand(salary_range),
        currency:        CURRENCIES[country] || "USD",
        hired_on:        rand(10.years.ago..Time.now).to_date,
        date_of_birth:   rand(60.years.ago..22.years.ago).to_date,
        active:          [ true, true, true, false ].sample,
        created_at:      Time.now,
        updated_at:      Time.now
      }
    end

    puts "Inserting 10,000 employees in parallel batches..."

    elapsed = Benchmark.realtime do
      Employee.delete_all

      batches = employees_data.each_slice(500).to_a

      threads = batches.map do |batch|
        Thread.new do
          ActiveRecord::Base.connection_pool.with_connection do
            Employee.import!(batch, validate: false)
          end
        end
      end

      threads.each(&:join)
    end

    count = Employee.count
    puts "Seeded #{count} employees in #{elapsed.round(2)}s"
  end
end
