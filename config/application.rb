require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Spotlight
  class Application < Rails::Application
    config.action_mailer.default_url_options = { host: "localhost:3000", from: "noreply@example.com" }
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    ## Remove?
    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true
    ##

    config.autoload_paths << Rails.root.join('lib')
  end
end
