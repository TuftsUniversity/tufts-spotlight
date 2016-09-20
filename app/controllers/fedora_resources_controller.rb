class FedoraResourcesController < Spotlight::ResourcesController
  private

  def resource_class
    FedoraResource
  end
end
