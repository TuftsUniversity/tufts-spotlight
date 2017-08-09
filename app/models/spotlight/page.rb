#@file
# Monkey patches for FeaturePages
require_dependency Spotlight::Engine.root.join('app', 'models', 'spotlight', 'page').to_s

module Spotlight
  class Page < ActiveRecord::Base
    include InMenuBehavior::PageModelPatch
  end
end
