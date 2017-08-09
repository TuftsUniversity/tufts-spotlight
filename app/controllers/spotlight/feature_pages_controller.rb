#@file
# Monkey Patches for Feature Pages Controller

require_dependency Spotlight::Engine.root.join('app', 'controllers', 'spotlight', 'feature_pages_controller').to_s

module Spotlight
  class FeaturePagesController < PagesController
    include InMenuBehavior::FeaturePagesControllerPatch
  end
end

