# frozen_string_literal: true
# PaperTrail serializes objects to YAML, so we need to permit these classes to be deserialized
if ActiveRecord.respond_to?(:yaml_column_permitted_classes)
  # Rails >= 7.0
  ActiveRecord.yaml_column_permitted_classes ||= []
  ActiveRecord.yaml_column_permitted_classes += [Symbol,
                                                 ActiveSupport::HashWithIndifferentAccess,
                                                 ActiveSupport::TimeWithZone,
                                                 ActiveSupport::TimeZone,
                                                 Time]

elsif ActiveRecord::Base.respond_to?(:yaml_column_permitted_classes)
  # Rails 6.1
  ActiveRecord::Base.yaml_column_permitted_classes ||= []
  ActiveRecord::Base.yaml_column_permitted_classes += [Symbol,
                                                       ActiveSupport::HashWithIndifferentAccess,
                                                       ActiveSupport::TimeWithZone,
                                                       ActiveSupport::TimeZone,
                                                       Time]
end
