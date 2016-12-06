class FedoraResourcesController < Spotlight::ResourcesController

  def create
    if @resource.save_and_index
      redirect_to spotlight.admin_exhibit_catalog_path(@resource.exhibit)
    else
      flash[:error] = @resource.errors.full_messages.to_sentence if @resource.errors.present?
      redirect_to spotlight.new_exhibit_resource_path(@resource.exhibit)
    end
  end

  private

  def resource_class
    FedoraResource
  end
end
