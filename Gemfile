source "https://rubygems.org"
ruby "3.2.0"

gem "rails", "~> 7.1.3.1"
gem "sprockets-rails", require: "sprockets/railtie"
gem "google-cloud-storage"
# gem "rack-cors"

# used to generate labels
gem "prawn", "2.4.0"

# action text images
# dreamhost doesn't have vips
#gem "image_processing", "~>1.2"
#gem "ruby-vips"

# for user password
gem "bcrypt", "~> 3.1.7"

# for sending emails in the background
gem "delayed_job"
gem "delayed_job_active_record"
gem "daemons"

# for dreamhost
gem "mysql2"

gem "puma", "~> 6.0"
# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails"

# Hotwire"s SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails"

# Hotwire"s modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails"

gem "bootsnap", require: false

gem "sassc-rails"

# for QB interface
gem "qbo_api", "~>3.0"
gem "rack-oauth2"
gem "rack", "2.2.8.1"

gem "matrix"
gem "trix"

group :development, :test do
  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  # Adds support for Capybara system testing and selenium driver
  gem "capybara", "~> 3.26"
  gem "selenium-webdriver"
  gem "webdrivers", "~> 4.0", require: false
  gem "simplecov"
  gem "standard"
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.3", require: false
  gem "capistrano-passenger"
  gem "ed25519", "~> 1.2"
  gem "bcrypt_pbkdf", "~> 1.0"
end
