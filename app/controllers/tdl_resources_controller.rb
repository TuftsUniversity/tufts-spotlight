class TdlResourcesController < Spotlight::ResourcesController
  private

  def resource_class
    TdlResource
  end
end
