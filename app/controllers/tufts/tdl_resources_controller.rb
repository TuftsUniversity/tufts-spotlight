module Tufts
  class TdlResourcesController < Spotlight::ResourcesController
    def resource_class
      Tufts::TdlResource
    end
  end
end