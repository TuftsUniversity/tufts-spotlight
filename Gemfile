# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.2.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '7.0.4'
# Use sqlite3 as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

gem 'blacklight', '8.6.0'
gem 'blacklight-spotlight', '4.3.6'
gem 'bootstrap_form', '~> 4.0'
gem 'rsolr'
gem 'solrizer'

gem 'blacklight-gallery'
gem 'blacklight-oembed'
gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'devise_invitable'
gem 'friendly_id'
gem 'riiif'
gem 'sitemap_generator'

gem 'devise_ldap_authenticatable'

# shib login
gem 'omniauth'
gem 'omniauth-shibboleth'

# fix omniauth issues https://nvd.nist.gov/vuln/detail/CVE-2015-9284
gem 'omniauth-rails_csrf_protection'

gem "bootstrap", "~> 4.0"
gem "sassc-rails", "~> 2.1"

# Tempoary until ruby 3 switch is finallized (come back after transistion)
gem 'base64', '0.1.1'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.3.0'
end

group :development, :test do
  gem 'bixby'
  gem 'byebug'
  gem 'ladle'
  gem 'rspec-rails'
  gem 'rubocop', require: false
  gem 'solr_wrapper'
  gem 'webrick'
end

group :test do
  gem 'capybara'
  gem 'capybara-maleficent', require: false
  gem 'capybara-screenshot'
  gem 'database_cleaner'
  gem 'factory_bot_rails'
  gem 'selenium-webdriver'
  gem 'simplecov'
  gem 'simplecov-lcov', '~> 0.8.0'
  gem 'webdrivers'
end
