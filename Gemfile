source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.1.6'
# Use sqlite3 as the database for Active Record
gem 'mysql2', '~> 0.3.18'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
#gem 'therubyracer', platforms: :ruby
gem 'mini_racer'

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Puma as the app server
# gem 'puma', '~> 3.0'

gem 'blacklight', ' ~> 6.0'
gem 'blacklight-spotlight', github: 'projectblacklight/spotlight'

gem 'rsolr', '>= 1.0'
gem 'solrizer'

gem 'devise'
gem 'devise-guests', '~> 0.6'
gem 'friendly_id'
gem 'riiif', '~> 1.0'
gem 'sitemap_generator'
gem 'blacklight-gallery', '>= 0.3.0'
gem 'blacklight-oembed', '>= 0.1.0'
gem 'devise_invitable'

gem 'bootstrap-sass', '~> 3.0'
gem 'twitter-typeahead-rails', '0.11.1.pre.corejavascript'

gem 'devise_ldap_authenticatable'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '>= 3.3.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  #gem 'spring'

  # Speeds things up more, but possibly unnecessary for our purposes
  #gem 'listen', '~> 3.0.5'
  #gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'solr_wrapper', '>= 0.3'

  gem 'rspec-rails'
  #gem 'guard-rspec'
  gem 'byebug'
  #gem 'sqlite3'
end

group :test do
  gem 'database_cleaner'
  gem 'capybara', '~> 2.13'
  gem 'ladle'
  gem 'factory_bot_rails'
  gem 'selenium-webdriver'
  gem 'chromedriver-helper'
end

