# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Spotlight
  class Application < Rails::Application
    config.action_mailer.default_url_options = { host: 'localhost:3000', from: 'noreply@example.com' }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.eager_load_paths << Rails.root.join('lib')

    # Un comment these if you need web console in dev
    # config.web_console.permissions = '0.0.0.0/0'
    # config.web_console.development_only = false
  end
end
