#@file
# Add our in_menu attribute to the controller.

module InMenuBehavior
  module FeaturePagesControllerPatch
    def allowed_page_params
      super.concat([:display_sidebar, :published, :in_menu])
    end
  end
end

