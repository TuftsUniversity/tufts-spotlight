# frozen_string_literal: true

module Tufts
  class TdlResourcesController < Spotlight::ResourcesController
    ##
    # @function
    #
    # Lets users input just the id of the resource, instead of the full manifest URL.
    # Also allows bulk importing.
    def create
      ids = params['resource']['ids']
      bad_ids = []
      successes = 0
      tufts_settings = Tufts::Settings.load

      ids.each do |id|
        id.strip!
        next if id.empty?

        manifest_url = "#{tufts_settings[:tdl_url]}#{id}/manifest.json"
        resource = TdlResource.new({ url: manifest_url, exhibit_id: @resource.exhibit_id })
        if resource.save_and_index
          successes += 1
        else
          bad_ids << id
        end
      end

      if successes.positive?
        plural = successes > 1 ? 's' : ''
        flash[:notice] = "Successfully created #{successes} record#{plural}. Indexing now. "\
                         'You may need to wait a second and reload the page to see your items.'
      end

      flash[:error] = "There was an error with the following ids -- #{bad_ids.join(' -- ') unless bad_ids.empty?}"

      redirect_to spotlight.admin_exhibit_catalog_path(@resource.exhibit)
    end

    def resource_class
      Tufts::TdlResource
    end
  end
end
