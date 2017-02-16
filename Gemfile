source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.6'
# Use sqlite3 as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
#gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'blacklight', ' ~> 6.0'
gem 'blacklight-spotlight', '>= 0.30.0', github: 'projectblacklight/spotlight'

gem 'rsolr', '~> 1.0'
gem 'devise'
gem 'devise-guests', '~> 0.5'
gem 'friendly_id', github: 'norman/friendly_id'
gem 'riiif', '~> 0.4.0'
gem 'sitemap_generator'
gem 'blacklight-gallery', '>= 0.3.0'
gem 'blacklight-oembed', '>= 0.1.0'
gem 'devise_invitable'

gem 'devise_ldap_authenticatable'
gem 'active-fedora', '~> 7.1.1'

#gem 'tufts_spotlight_blocks', path: '../tufts_spotlight_blocks'
gem 'tufts_spotlight_blocks', github: 'TuftsUniversity/tufts_spotlight_blocks'

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-commands-rspec'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.5.0'
  gem 'guard-rspec'
  gem 'byebug'
  gem 'solr_wrapper', '>= 0.3'
  gem 'jettywrapper', '1.8.3'
  gem 'sqlite3'
end

group :test do
  gem 'database_cleaner'
  gem 'capybara'
  gem 'ladle'
  gem 'factory_girl_rails'
end


