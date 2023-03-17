# frozen_string_literal: true

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
        indexer_args = %i[stored_searchable facetable]

        ::Solrizer.insert_field(
          hash,
          key.tr(' ', '_').downcase,
          value,
          *indexer_args
        )
      end
    end

    ##
    # @function
    # Overrides Spotlight::Resources::IiifManifest.add_metadata
    #
    # Because the default IiifManifest saves fields as custom fields,
    #   this method adds all the metadata to the sidecar.
    #
    # We're not doing custom fields, so we don't need data in the sidecar .
    def add_metadata
      solr_hash.merge!(manifest_metadata)
    end
  end
end
