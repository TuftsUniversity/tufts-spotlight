# config/initializers/active_record.rb
# this has to be here because we need MyClass, which isn't loaded early enough to do in environments/production.rb

Rails.application.config.after_initialize do
  # This resolves an issue loading symbols causing pysch disallowed class error
  # Check out https://discuss.rubyonrails.org/t/cve-2022-32224-possible-rce-escalation-bug-with-serialized-columns-in-active-record/81017
  ActiveRecord.yaml_column_permitted_classes = [Symbol, Hash, HashWithIndifferentAccess]
end