#@file
# Monkey patches for FeaturePages
require_dependency Spotlight::Engine.root.join('app', 'models', 'spotlight', 'page').to_s

module Spotlight
  class Page < ActiveRecord::Base
    # Add our special, in_menu attribute.
    scope :in_menu, -> { where(in_menu: true) }
  end
end
