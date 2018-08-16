module Tufts
  class TdlResourcesController < Spotlight::ResourcesController

    ##
    # @function
    #
    # Lets users input just the id of the resource, instead of the full manifest URL.
    # Also allows bulk importing.
    def create
      ids = params["resource"]["ids"]
      bad_ids = []
      successes = 0

      ids.each do |id|
        id.strip!
        if(id.empty?)
          next
        end

        manifest_url = "#{tufts_settings[:tdl_url]}#{id}/manifest.json"
        resource = TdlResource.new({url: manifest_url, exhibit_id: @resource.exhibit_id})
        if(resource.save_and_index)
         successes += 1
        else
         bad_ids << id
        end
      end

      if(successes > 0)
       plural = successes > 1 ? "s" : ""
       flash[:notice] = "Successfully created #{successes} record#{plural}. Indexing now. "\
                        "You may need to wait a second and reload the page to see your items."
      end

      unless(bad_ids.empty?)
       flash[:error] = "There was an error with the following ids -- " + bad_ids.join(" -- ")
      end

      redirect_to spotlight.admin_exhibit_catalog_path(@resource.exhibit)
    end

    ##
    # @function
    # Loads and saves config from config/tufts.yml to @tufts_settings.
    def tufts_settings
      if(@tufts_settings.nil?)
        file = Rails.root.join("config/tufts.yml").to_s
        @tufts_settings = YAML::load(File.open(file)).deep_symbolize_keys![Rails.env.to_sym]
      end
      @tufts_settings
    end

    def resource_class
      Tufts::TdlResource
    end
  end
end