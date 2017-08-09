#@file
# Add in_menu scope to the page model.

module InMenuBehavior
  module PageModelPatch
    extend ActiveSupport::Concern
    included do
      scope :in_menu, -> { where(in_menu: true) }
    end
  end
end

