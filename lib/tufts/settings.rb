# frozen_string_literal: true

##
# @module
# A simple function call to load our Tufts yaml.
module Tufts
  module Settings
    def self.load
      file = Rails.root.join('config', 'tufts.yml').to_s
      YAML.safe_load(File.open(file)).deep_symbolize_keys![Rails.env.to_sym]
    end
  end
end
