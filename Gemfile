source "https://rubygems.org"

gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "bootstrap"
gem "sassc-rails"
gem "cancancan"
gem "grape"
gem "grape-entity"
gem "grape_on_rails_routes"
gem "i18n"
gem "importmap-rails"
gem "jbuilder"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "prawn"
gem "pry"
gem "rails", "~> 7.2.1", ">= 7.2.1.1"
gem "ransack"
gem "sidekiq"
gem "sprockets-rails"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development do
  gem "letter_opener"
  gem "web-console"
end

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "dotenv-rails"
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "factory_bot_rails"
  gem "rails-controller-testing"
  gem "rspec-rails"
  gem "shoulda-matchers", "~> 6.0"
end
