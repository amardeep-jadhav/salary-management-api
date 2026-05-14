source "https://rubygems.org"

ruby "3.4.5"
gem "rails", "~> 8.1.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "bootsnap", require: false
gem "rack-cors"
gem "blueprinter"
gem "pagy", "~> 43.5"
gem "activerecord-import"
gem "benchmark"
gem "redis"

group :development, :test do
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "shoulda-matchers"
  gem "database_cleaner-active_record"
  gem "dotenv-rails"
end

gem "thruster", require: false

group :development do
  gem "bundler-audit", require: false
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end
