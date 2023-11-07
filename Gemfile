# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.0.2'
# Use sqlite3 as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
# gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
# gem 'mini_racer'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
# gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

gem 'blacklight', '7.24.0'
# this version is a guess come back ad decide this
# First verison v3.4.0 that supports Rails 7
# https://github.com/projectblacklight/spotlight/releases
# First version v3.0.0 to supports Rails 6
gem 'blacklight-spotlight', tag: 'v3.4.0', git: 'https://github.com/projectblacklight/spotlight.git'
gem 'rsolr', '>= 1.0'
gem 'solrizer'

gem 'blacklight-gallery'
gem 'blacklight-oembed'
gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'devise_invitable'
gem 'friendly_id'
gem 'riiif'
gem 'sitemap_generator'

gem 'bootstrap-sass', '~> 3.0'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'

gem 'devise_ldap_authenticatable'

# shib login
gem 'omniauth', '1.9.1'
gem 'omniauth-shibboleth'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  # gem 'spring'
  # gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'bixby', '3.0.2'
  gem 'byebug'
  gem 'rspec-rails', '~> 4' # Can update to 5.x after updating to Rails 6.x
  gem 'rubocop', require: false
  gem 'solr_wrapper', '~> 2' # hi
end

group :test do
  gem 'capybara'
  gem 'capybara-maleficent', require: false
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'ladle'
  gem 'selenium-webdriver', '~> 4.1.0'
  gem 'simplecov'
  gem 'simplecov-lcov', '~> 0.8.0'
  gem 'webdrivers', '~> 4.0', require: false
end
