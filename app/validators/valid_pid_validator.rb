##
# @file
# The model validator that checks if a pid is in fedora.

class ValidPidValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless(ActiveFedora::Base.exists?(value))
      record.errors[attribute] << ("is not a valid pid")
    end
  end
end

