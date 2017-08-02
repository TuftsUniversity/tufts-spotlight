#@file
# Monkey patches FeaturePages
require_dependency Spotlight::Engine.root.join('app', 'controllers', 'spotlight', 'feature_pages_controller').to_s

module Spotlight
  class FeaturePagesController < PagesController
    # Add our in_menu attribute to the controller.
    def allowed_page_params
      super.concat([:display_sidebar, :published, :in_menu])
    end
  end
end
