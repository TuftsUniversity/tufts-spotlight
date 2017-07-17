class FedoraResourcesController < Spotlight::ResourcesController

  def create
    ids = params["resource"]["ids"]
    bad_ids = []
    success = 0

    ids.each do |id|
      id.strip!

      if(id.empty?)
        next
      end

      resource = FedoraResource.new({url: id, exhibit_id: @resource.exhibit_id})
      if(resource.save)
        success += 1
        resource.reindex_later
      else
        bad_ids << id
      end
    end

    if(success > 0)
      record = success > 1 ? "records" : "record"
      flash[:notice] = "Successfully created #{success} #{record}. Preparing to index."
    end

    unless(bad_ids.empty?)
      flash[:error] = "There was an error with the following ids -- " + bad_ids.join(" -- ")
    end

    redirect_to spotlight.admin_exhibit_catalog_path(@resource.exhibit)
  end

  private

  def resource_class
    FedoraResource
  end
end
