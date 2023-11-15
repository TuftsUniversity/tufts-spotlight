# frozen_string_literal: true

require 'i18n/backend/active_record'

unless defined?(Translation)
  Translation = I18n::Backend::ActiveRecord::Translation
  Translation.include Spotlight::CustomTranslationExtension

  # Work-around for https://github.com/svenfuchs/i18n-active_record/pull/133
  if Translation.respond_to?(:to_hash)
    class << Translation
      alias to_h to_hash
      remove_method :to_hash
    end

    I18n::Backend::ActiveRecord.define_method(:init_translations) do
      @translations = Translation.to_h
    end
  end
end

#  Temp try the. version of this file from spotlight
# if Translation.table_exists?
#   ##
#   # Sets up the new Spotlight Translation backend, backed by ActiveRecord. To
#   # turn on the ActiveRecord backend, uncomment the following lines.

#   # I18n.backend = I18n::Backend::ActiveRecord.new
#   I18n::Backend::ActiveRecord.include I18n::Backend::Memoize
#   Translation.include Spotlight::CustomTranslationExtension
#   I18n::Backend::Simple.include I18n::Backend::Memoize
#   I18n::Backend::Simple.include I18n::Backend::Pluralization

#   # I18n.backend = I18n::Backend::Chain.new(I18n.backend, I18n::Backend::Simple.new)
# end
