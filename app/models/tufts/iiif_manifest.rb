module Tufts
  class IiifManifest < Spotlight::Resources::IiifManifest

    ##
    # @function
    # Overrides Spotlight::Resources::IiifManifest.manifest_metadata
    #
    # The Spotlight manifest handler submits all fields as exhibit-specific fields.
    #
    # This submits them as core blacklight fields - so they must be defined
    #   in catalog_controller to display.
    #
    # However, this lets us define them as facets. I don't see any way to use IIIF
    #   fields as facets in the current Spotlight setup.
    def manifest_metadata
      metadata = metadata_class.new(manifest).to_solr
      return {} unless metadata.present?

      metadata.each_with_object({}) do |(key, value), hash|
        # Storing everything as potentially facetable for now.
        indexer_args = [:stored_searchable, :facetable]

        Solrizer.insert_field(
          hash,
          key.tr(' ', '_').downcase,
          value,
          *indexer_args
        )
      end
    end
  end
end