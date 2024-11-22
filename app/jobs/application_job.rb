# frozen_string_literal: true

# Spotlight 3.4 has this file maybe get rid of this.
class ApplicationJob < ActiveJob::Base
  queue_as :default
end
