source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "2.7.5"

gem "bootsnap", require: false
gem "brakeman"
gem "browser"
gem "bundle-audit"
gem "cssbundling-rails"
gem "devise"
gem "dotenv-rails"
gem "feedjira"
gem "haml"
gem "httparty"
gem "importmap-rails"
gem "jbuilder"
gem "jsbundling-rails"
gem "kaminari"
gem "mina"
gem "nokogiri"
gem "pg"
gem "puma", "~> 5.0"
gem "rails", "~> 7.0.2", ">= 7.0.2.2"
gem "redis", "~> 4.0"
gem "rubocop"
gem "sidekiq"
gem "sidekiq-cron"
gem "sprockets-rails"
# gem "sqlite3", "~> 1.4"
gem "stimulus-rails"
gem "strscan", "1.0.3" # lock it for now
gem "turbo-rails"

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot_rails"
  gem "faker"
  gem "rspec-rails"
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "rails-controller-testing"
  gem "selenium-webdriver"
  gem "webdrivers"
end
