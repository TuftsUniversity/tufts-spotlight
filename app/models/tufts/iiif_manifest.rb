module Tufts
  class IiifManifest < Spotlight::Resources::IiifManifest

    ##
    # The spotlight manifest handler submits all fields as exhibit-specific fields
    def manifest_metadata
      metadata = metadata_class.new(manifest).to_solr
      return {} unless metadata.present?

      metadata.each_with_object({}) do |(key, value), hash|
        # Storing everything as potentially facetable for now.
        indexer_args = [:stored_searchable, :facetable]

        Solrizer.insert_field(
          hash,
          key.downcase,
          value,
          *indexer_args
        )
      end
    end
  end
end