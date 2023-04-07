# frozen_string_literal: true

# @file
# Add our in_menu attribute to the controller.

module InMenuBehavior
  module FeaturePagesControllerPatch
    def allowed_page_params
      super.concat(%i[display_sidebar published in_menu])
    end
  end
end
