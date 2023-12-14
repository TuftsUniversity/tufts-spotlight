# frozen_string_literal: true

require 'i18n/backend/active_record'
require 'i18n/backend/fallbacks'

ActiveSupport::Reloader.to_prepare do
  # Don't allow initializer to break if DB doesn't exist yet
  # see: https://github.com/projectblacklight/spotlight/issues/2133
  if ENV['SKIP_TRANSLATION'].blank?
    # raise unless Translation.table_exists?

    ##
    # Sets up the new Spotlight Translation backend, backed by ActiveRecord. To
    # turn on the ActiveRecord backend, uncomment the following lines.
    I18n.backend = I18n::Backend::ActiveRecord.new
    I18n::Backend::ActiveRecord.include I18n::Backend::Memoize
    I18n::Backend::Simple.include I18n::Backend::Memoize
    I18n::Backend::Simple.include I18n::Backend::Pluralization
    I18n::Backend::Simple.include I18n::Backend::Fallbacks

    I18n.backend = I18n::Backend::Chain.new(I18n.backend, I18n::Backend::Simple.new)
  end
end

# frozen_string_literal: true

# require 'i18n/backend/active_record'

# Translation = I18n::Backend::ActiveRecord::Translation

# if Translation.table_exists?
#   ##
#   # Sets up the new Spotlight Translation backend, backed by ActiveRecord. To
#   # turn on the ActiveRecord backend, uncomment the following lines.

#   # I18n.backend = I18n::Backend::ActiveRecord.new
#   I18n::Backend::ActiveRecord.include I18n::Backend::Memoize
#   # temp why does this not work
#   # Translation.include Spotlight::CustomTranslationExtension
#   I18n::Backend::Simple.include I18n::Backend::Memoize
#   I18n::Backend::Simple.include I18n::Backend::Pluralization

#   # I18n.backend = I18n::Backend::Chain.new(I18n.backend, I18n::Backend::Simple.new)
# end

# unless defined?(Translation)
#   Translation = I18n::Backend::ActiveRecord::Translation
#   Translation.include Spotlight::CustomTranslationExtension

#   # Work-around for https://github.com/svenfuchs/i18n-active_record/pull/133
#   if Translation.respond_to?(:to_hash)
#     class << Translation
#       alias to_h to_hash
#       remove_method :to_hash
#     end

#     I18n::Backend::ActiveRecord.define_method(:init_translations) do
#       @translations = Translation.to_h
#     end
#   end
# end
